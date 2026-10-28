# The Moving Parts

Helm has one program, one package
format, one settings system, one
distribution mechanism and one piece
of cluster-side state. Five parts;
this chapter names them and says which
holds what, so later surprises have
somewhere to land.

## The helm program

Everything runs through a single
command-line tool, `helm`. It reads
charts, renders templates, talks to
repositories, and — when a cluster is
involved — talks to the cluster using
the same **kubeconfig** credentials
`kubectl` uses. Helm 4, which this
guide uses, needs no server-side
companion: earlier generations ran a
component inside the cluster, but that
design is long gone, and a chart is
installed entirely by the program on
your desk. That matters for trust
(chapter 1): the hands on your cluster
are *your* hands, holding credentials
you already have.

The program keeps its own state in
three folders — a **config** folder
(which repositories you have added), a
**cache** folder (downloaded repository
indexes and charts), and a **data**
folder. Chapter 3 shows them with
`helm env`.

## The chart

A **chart** is a folder:

```text
hello/
  Chart.yaml          what this chart is, and its version
  values.yaml         the default settings
  values.schema.json  (optional) rules the settings must obey
  templates/          the manifests, as templates
    deployment.yaml
    service.yaml
    _helpers.tpl      shared template fragments
    NOTES.txt         the message shown after an install
  charts/             (optional) charts this one depends on
  .helmignore         what packaging leaves out
```

`Chart.yaml` is the chart's identity
card: its name, its own **chart
version**, and the **appVersion** — the
version of the application it installs.
The two versions are separate on
purpose (chapter 9). The templates are
ordinary Kubernetes manifests with
`{{ ... }}` instructions mixed in;
rendering is the act of carrying those
instructions out.

## Values

**Values** are the settings a chart
exposes: image names and tags, replica
counts, ports, greetings, switches for
optional pieces. The chart ships
defaults in `values.yaml`; the person
installing supplies their own in three
ways — more values files, individual
`--set` overrides, and the values of a
parent chart when this chart is a
dependency. Chapter 6 is the whole
story, including the order in which
they win. Templates read values as
`.Values`, one branch of the data
every template can see.

## Repositories

A **chart repository** is any web
server holding packaged charts plus
one special file, `index.yaml`, which
lists every chart, every version, and
a checksum for each. `helm repo add`
registers one; `helm repo update`
refreshes its index; from then on the
charts are addressable as
`repo-name/chart-name`. A repository
is not a service Helm runs — chapter
10 builds one out of a folder and a
small Python web server. (Charts can
also live in OCI registries, the same
stores container images use; that
route is described in chapter 10 and
labelled documented-only.)

## Releases

When a chart is installed, Helm
records a **release**: the chart, the
final merged values, the rendered
manifests, a status, and a revision
number. The record lives in the
cluster itself (by default as Secrets
in the release's namespace — chapter
11). Upgrades add revisions; a
rollback is a return to an earlier
revision's manifests. Releases are the
one part of Helm that exists only on a
cluster, which is why they are the one
part this guide teaches from
documentation: the lab could render
everything a release *would* contain,
but could not create one.

## The template engine

Templates are written in Go's template
language with a shelf of extra
functions (Sprig) and a few of Helm's
own (`include`, `required`, `tpl`).
The engine's inputs are the built-in
objects: `.Values`, `.Release` (the
release's name, namespace, revision),
`.Chart` (the identity card, as data),
`.Capabilities` (what the cluster
claims to support), and `.Files`.
Chapter 7 uses the common ninety
percent. The engine also explains
Helm's sharpest edge (chapter 14): a
chart is code, and reading code is
work — which is exactly what the trust
rule asks of you.

Check: each part named here appears in
the lab within a few chapters — the
program in chapter 3, the chart in
chapters 4 and 5, values in chapter 6,
the repository in chapter 10, and the
release, by its documented outline and
its one local shadow (`--dry-run=client`),
in chapter 11.
