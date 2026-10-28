# Anatomy of a Chart

Outcome: a chart small enough to hold
in your head — the lab's own `hello`
chart — read file by file, so the
scaffold's bulk becomes a set of named
choices rather than a mystery.

The scaffold is a fine reference and a
poor teacher: nine templates, most of
them conditional, helpers for every
naming corner. The lab wrote a second
chart instead: a tiny web server,
nine files, nothing conditional except
one optional Ingress. It lives in this
repository at `helm-lab/charts/hello/`
and the rest of the guide works on it.

## Chart.yaml — the identity card

```yaml
apiVersion: v2
name: hello
description: A tiny web server, packaged as a chart to learn Helm with
type: application
version: 0.1.0
appVersion: "1.0.0"
```

`apiVersion: v2` is the chart format's
version (Helm 3 and 4 use it; it is
not the application's). `name` is how
the chart is addressed in repositories.
`type: application` says this chart
installs things, as opposed to a
**library chart**, which only supplies
template fragments to other charts.
`version` is the chart's own version —
it starts at `0.1.0` here and chapter 9
bumps it — and `appVersion` is the
version of the thing being installed.
They differ because they change for
different reasons: fix a template and
the chart version moves; ship a new
server and the app version moves.

The scaffold's Chart.yaml carries long
comments explaining each field —
generated documentation, worth the
read once (transcript `t01`).

## values.yaml — the defaults

```yaml
replicaCount: 1

image:
  repository: nginx
  tag: "1.27"
  pullPolicy: IfNotPresent

message: "Hello from the hello chart"

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  host: hello.example.test
```

Every value here is a promise to the
templates: *these names exist, with
these shapes*. Templates read them as
`.Values.replicaCount`,
`.Values.image.tag`, and so on.
Chapter 6 is about replacing them
without editing them.

## values.schema.json — the contract

The lab's chart carries one optional
extra the scaffold does not: a
**schema** for its values, stating
that `replicaCount` is an integer
between 1 and 10 and `service.port` a
plausible port. Helm checks merged
values against it before rendering.
Chapter 8 shows it refusing a
`replicaCount` of `"three"` — the
schema is how a chart author says
"these settings have rules" in a way
the machine enforces.

## templates/ — the manifests, unfinished

Three templates do the work:

- `deployment.yaml` runs the server.
  Its image line is the chart in
  miniature —
  `image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"`
  — two values stitched into the exact
  string Kubernetes wants. It also
  passes the greeting to the container
  as an environment variable, using
  `required` so an empty greeting fails
  the render instead of starting a
  silent server (chapter 8 returns to
  this).
- `service.yaml` gives the server its
  address, its `type` and `port` taken
  from values.
- `ingress.yaml` is wrapped whole in
  `{{- if .Values.ingress.enabled }}`,
  so by default it renders to nothing
  at all — the scaffold's pattern,
  kept deliberately.

Two files support them. `_helpers.tpl`
holds named fragments (`define`d, then
`include`d) for names and labels, so
the five places that need the release's
full name all compute it the same way.
`NOTES.txt` is a template too — it
renders *after* an install, as a
message to the human; chapter 11 shows
it rendered by the client dry run.

## Names and labels, once more

Render the chart under a release name
of `greetings` (transcript `t03`):

```bash
helm lint charts/hello
helm template greetings ./charts/hello
```

```text
==> Linting charts/hello
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, 0 chart(s) failed
```

and in the render, every resource is
named `greetings-hello` — release name
and chart name joined by the
`hello.fullname` helper — and labelled
with the chart version, the release
name, and `app.kubernetes.io/managed-by:
Helm`. Two releases of this chart in
one cluster would differ in every name,
because the release name differs. That
is the quiet machinery that makes
"install it twice" an ordinary
sentence.

Check: lint passes (one informational
note about an icon, no failures), and
the render shows a Service and a
Deployment, both named
`greetings-hello`, the Deployment
carrying the greeting
`"Hello from the hello chart"` in its
environment. The chart is nine files
and you have now seen what each is
for.
