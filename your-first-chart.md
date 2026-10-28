# Your First Chart

Outcome: a complete chart Helm wrote
for you, rendered and read — the
fastest way to learn what a chart is
made of before writing one.

## helm create

Helm can write a starter chart:

```bash
helm create demo
```

```text
Creating demo
```

The lab's transcript
`helm-lab/transcripts/t01-create-scaffold.txt`
keeps the resulting tree:

```text
demo/.helmignore
demo/Chart.yaml
demo/templates/NOTES.txt
demo/templates/_helpers.tpl
demo/templates/deployment.yaml
demo/templates/hpa.yaml
demo/templates/httproute.yaml
demo/templates/ingress.yaml
demo/templates/service.yaml
demo/templates/serviceaccount.yaml
demo/templates/tests/test-connection.yaml
demo/values.yaml
```

Read it as a claim about what a real
application needs: something to run it
(`deployment.yaml`), something to
reach it (`service.yaml`), an identity
(`serviceaccount.yaml`), optional ways
in (`ingress.yaml`, `httproute.yaml`),
optional scaling (`hpa.yaml`), a test
(`templates/tests/`), a message for
the human afterwards (`NOTES.txt`),
shared fragments (`_helpers.tpl`), and
the settings (`values.yaml`) that let
one chart serve many sites. The
scaffold's application is nginx with
sensible armour; its `Chart.yaml`
(chapter 5 takes it apart field by
field) starts at version `0.1.0` with
`appVersion: "1.16.0"`.

Most of those files are *conditional*:
the default values switch the ingress,
the autoscaler and the route off, so
the scaffold ships with more chart
than it uses — a pattern worth
remembering when chapter 5 trims it.

## Rendering it

Rendering needs a **release name** —
the name this installation will go by
— and the chart:

```bash
helm template demo ./demo
```

`helm template RELEASE CHART` renders
entirely on your machine and prints
the manifests to the screen. The
output is a series of YAML documents,
each introduced by a comment naming
the template that produced it. The
lab counted four `kind:` lines with
default values: ServiceAccount,
Service, Deployment — and the fourth
is the test pod, which carries a
**hook** annotation marking it as a
test rather than part of the running
application (hooks get their due in
chapter 11).

One document, from transcript
`helm-lab/transcripts/t02-scaffold-render.txt`:

```text
---
# Source: demo/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  labels:
    helm.sh/chart: demo-0.1.0
    app.kubernetes.io/name: demo
    app.kubernetes.io/instance: demo
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
```

Three things to notice, because they
recur in every chart. The **labels**
tell the whole story of provenance:
which chart and version, which release
(`app.kubernetes.io/instance: demo`),
and who manages this object — Helm.
The **name** is just `demo` here
because the release name and the chart
name coincide; chapter 5's chart shows
what happens when they do not. And the
document is *finished* YAML: no
placeholders remain. Whatever is
printed is exactly what a cluster
would be given.

## Reading one file at a time

Whole renders get long. `--show-only`
restricts the output to the documents
from named templates:

```bash
helm template demo ./demo --show-only templates/service.yaml
```

The lab used it to print just the
Service above. It is the reading tool
for the rest of this guide — and, in
chapter 12, part of how you examine a
stranger's chart without drowning in
it.

Check: you can run the two commands
and match the lab's output document
for document. Nothing has been
installed, nothing has left the
machine, and you have already done
the thing Helm exists to do — turned
a chart and a name into manifests you
can read.
