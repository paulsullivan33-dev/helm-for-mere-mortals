# Linting and Debugging

Outcome: three broken charts, three
different confessions — and the habit
of letting `helm lint` and
`helm template` find your faults on
your desk instead of the cluster
finding them in production.

## The clean pass

`helm lint` renders a chart with its
own default values, checks the
Chart.yaml's shape, and reports in a
form made to be read:

```bash
helm lint charts/hello
```

```text
==> Linting charts/hello
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

The `[INFO]` line is a suggestion, not
a fault — a chart may add an icon for
catalogues. Lint exits 0. Everything
below is what failure looks like, from
transcript `helm-lab/transcripts/t05-lint-catches.txt`,
where the lab broke the chart three
different ways on purpose.

## Break one: a function that does not exist

The Service template was edited to
pipe its type through a function named
`shout`, which no part of Helm
provides:

```yaml
type: {{ .Values.service.type | shout }}
```

```text
$ helm lint broken
==> Linting broken
[INFO] Chart.yaml: icon is recommended
[ERROR] templates/: parse error at (hello/templates/service.yaml:8): function "shout" not defined

Error: 1 chart(s) linted, 1 chart(s) failed
```

Lint exits 1, and the error names the
file and the line. This is a *parse*
error: the template cannot even be
read. Typos in function names, helpers
called with the wrong name, and
unbalanced `{{` live in this family,
and the errors are this direct once
you read them literally — the text
tells you the file, the line, and the
name it could not find.

## Break two: a value of the wrong type

No template was harmed for this one.
A values file set:

```yaml
replicaCount: "three"
```

and the chart's own schema (chapter 5)
refused it:

```text
$ helm lint charts/hello -f values-bad.yaml
[ERROR] values.yaml: - at '/replicaCount': got string, want integer
[ERROR] templates/: values don't meet the specifications of the schema(s) in the following chart(s):
hello:
- at '/replicaCount': got string, want integer

Error: 1 chart(s) linted, 1 chart(s) failed
```

Without the schema, this fault would
have rendered happily into
`replicas: three` and been the
cluster's problem. The schema is the
chart author's one chance to say
*integers, in this range* and have
the machine enforce it for every
future user — including the author.

## Break three: the template refuses

The Deployment wraps the greeting in
`required`, so an empty greeting is a
rendering error with the author's own
words in it:

```text
$ helm template greetings ./charts/hello --set message=
Error: execution error at (hello/templates/deployment.yaml:23:24): message must not be empty: the server has nothing to say
```

`23:24` is line and column — Helm
points into the template, not the
output. Some faults belong to neither
the chart's syntax nor its values but
to its judgement, and `required` is
how a template states them.

## --debug: seeing the refused render

The subtlest family is a template
that renders *successfully* into YAML
that is itself invalid — the values
were legal, the output is not. Feed
the Service a type with a colon in it:

```bash
helm template greetings ./charts/hello \
  --set service.type="ClusterIP: extra"
```

```text
Error: YAML parse error on hello/templates/service.yaml: error converting YAML to JSON: yaml: line 11: mapping values are not allowed in this context

Use --debug flag to render out invalid YAML
```

Helm withholds the broken output (a
kindness: invalid YAML printed without
comment becomes someone else's bug
report). `--debug` releases it, so you
can see the offending line in place:

```bash
helm template greetings ./charts/hello \
  --set service.type="ClusterIP: extra" --debug
```

The render appears, line 11 carrying
`type: ClusterIP: extra` — a mapping
inside a mapping, exactly as the error
said (transcript `t06b`). In Helm 4,
`--debug` also narrates the working on
stderr — chart paths, the schema read,
the dependency count (transcript
`t06`) — which is noise on a good day
and a map on a bad one.

Check: copy the lab chart, break it
each of the three ways, and make lint
or template produce each confession.
The exit code is part of every
transcript in this chapter on purpose:
in scripts and CI, `1` is the sentence
these errors serve.
