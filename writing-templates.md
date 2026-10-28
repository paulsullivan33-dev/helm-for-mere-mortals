# Writing Templates

Outcome: the template instructions in
the lab chart stop looking like
punctuation and start reading as
sentences — enough of the language to
write your own chart and to read a
stranger's.

A template is YAML with instructions
in double braces. Anything outside
`{{ ... }}` is copied through exactly.
Inside, the instruction is an
expression, usually a **pipeline**:
a value flowing left to right through
functions, each stage reshaping it.

```text
{{ .Values.image.repository }}
{{ include "hello.labels" . | nindent 4 }}
{{ required "a message" .Values.message | quote }}
```

Read the second one as its author
meant it: *take the fragment named
`hello.labels`, rendered in this
context, and indent what it produces
by four spaces*. Pipelines are why
Helm templates read backwards to
newcomers — the subject comes first,
the verbs after — and forwards once
the habit forms.

## The data every template can see

Four built-in objects are always in
reach (chapter 2 named them; here is
what they feel like in practice):

- `.Values` — the merged settings.
  `.Values.service.port` walks the
  structure exactly as the values file
  wrote it.
- `.Release` — `.Release.Name`,
  `.Release.Namespace`,
  `.Release.Revision`, `.Release.Service`
  (which is the string `Helm` — it is
  where the `managed-by` label's value
  comes from).
- `.Chart` — the identity card as
  data: `.Chart.Name`, `.Chart.Version`,
  `.Chart.AppVersion`.
- `.Capabilities` and `.Template` —
  what the cluster claims to support,
  and the current file's own name.
  `.Capabilities` is the one to treat
  gently in this guide: with no cluster,
  `helm template` fills it with
  defaults, so a template that branches
  on it can render one thing here and
  another on a real install. Chapter
  14 lists that among the honest gaps.

One warning that saves an afternoon:
inside a `range` or `with` block, the
meaning of `.` changes to the item in
hand, and `.Values` stops working —
the top-level data is then reached as
`$.Values`. Most "my template sees
nothing" bugs are this one.

## Defining and including

`_helpers.tpl` exists so a fragment is
written once:

```yaml
{{- define "hello.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}
```

Note the dashes: `{{-` and `-}}` trim
the whitespace around the instruction,
so the fragment emits exactly its
content and no stray blank lines.
Templates that forget the dashes
produce YAML with mysterious extra
indentation's quieter cousin — blank
lines everywhere, usually harmless,
always untidy.

`include` renders a named fragment as
a string, which is why it composes
with pipelines like `nindent`. (Its
older sibling `template` writes
straight to the output and cannot be
piped; new charts use `include`.)

The scaffold's helpers add one more
move worth recognising (transcript
`t01` keeps them): `default` supplies
a fallback when a value is empty, and
names are run through
`trunc 63 | trimSuffix "-"` because
Kubernetes caps name lengths at 63
characters. The lab chart skipped
those — a teaching simplification, and
chapter 14 owns it.

## Conditions, loops and guards

The Ingress from chapter 5 is the
condition in its whole form:

```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
...
{{- end }}
```

`range` walks a list or a map — an
environment made of several variables,
a set of ports — emitting its block
once per item. And two functions do
safety work:

- `required "message" value` renders
  the value, or stops the whole render
  with your message if it is empty.
  The lab chart uses it for the
  greeting, and chapter 8 shows it
  firing.
- `quote` wraps a value in quotes, so
  a greeting with a colon or a leading
  digit cannot accidentally change the
  YAML's meaning. Strings from values
  should nearly always be quoted in
  output; numbers and booleans nearly
  never.

That is the working ninety percent:
pipelines, `include`, `if`, `range`,
`required`, `quote`, `default`,
`nindent`, `printf`. The rest of the
function shelf — several hundred
entries from the Sprig library — is
reference material, and a template
that needs most of it is a template
asking to be simplified (chapter 14).

Check: open `helm-lab/charts/hello/templates/`
and find each device named here, in
situ — the pipeline in the Deployment's
image line, the `if` around the
Ingress, `required` on the greeting,
the helpers behind every name and
label in the render from chapter 5.
