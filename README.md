# Helm for Mere Mortals

A Kubernetes application is rarely one
thing. It is a Deployment, a Service,
some configuration, maybe an account and
a password — half a dozen **manifests**,
written in YAML, that only work together
and only in the right shape. Installing
the application means applying all of
them, with the right names, the right
labels, and the settings this particular
site needs. **Helm** is the tool that
packages that bundle: one **chart** holds
the manifests as **templates**, one
**values** file holds the settings, and
one command turns the two into the exact
manifests for *your* cluster. Change the
values, and the same chart fits the next
site too.

This guide explains how that works. It
writes a small chart from scratch, takes
apart the scaffold Helm generates, and
follows the whole local craft: rendering
templates and reading what comes out,
shaping the output with values files and
command-line overrides, linting until a
broken chart confesses, packaging a chart
into a versioned archive, and publishing
it through a chart repository you run
yourself. The cluster half of Helm —
install, upgrade, rollback — is taught
just as carefully, and labelled for what
it is in this guide: described from
Helm's own help and documentation,
because the lab had no cluster, and this
guide does not pretend otherwise.

Two rules run through everything here.
The first is about trust: **a chart is
software from whoever wrote it, and
installing one hands it your cluster's
keys — read a chart before you install
it, and only ever install onto clusters
that are yours to change.** Chapter 1
states it in full. The second is about
evidence: everything this guide claims
Helm does locally, the lab did, on one
machine, with no cluster at all — and
the boundary where a cluster would have
to enter the story is shown, not hidden.

The lab behind this guide ran the real
thing: **Helm 4.3.1**, the official
release binary, its checksum verified
against the project's published sum. With
it the lab generated Helm's scaffold
chart and rendered it, then wrote its
own small chart — a tiny web server —
and linted it clean. Values overrides
were proven with diffs: the same chart
rendered with defaults, with a second
values file, and with `--set`, and the
changed lines counted (five). Lint was
then shown catching three real faults —
a template function that does not exist,
a value of the wrong type caught by the
chart's own schema, and a template
refusing an empty setting it requires —
each with its error text and exit code.
The chart was packaged at two versions,
indexed, and served from a local chart
repository; Helm added that repository,
searched it, showed the chart from it,
pulled an older version out of it, and
rendered straight from it.

What the lab could not do, it did not
fake. There is no Kubernetes cluster on
the lab machine, so `helm install` and
`helm list` were run only far enough to
show their first, honest answer — the
cluster is unreachable — and everything
past that line (releases, upgrades,
rollbacks, hooks firing, uninstalls) is
taught from Helm's documentation and
marked documented-only wherever it
appears. One thing *was* reachable and
is shown: `helm install --dry-run=client`,
which renders an install entirely on
your own machine, greeting notes and
all. A public chart repository was also
attempted; the lab's network let the
request sit unanswered past ninety
seconds, so the repository chapter rests
on the local one, which is complete.
`criteria.md` keeps the full ledger of
what was run and what was only read.

## What this guide covers

- [**What Helm is**](what-helm-is.md) —
  the mental model: manifests bundled
  into charts, charts shaped by values,
  and the trust rule that is part of the
  tool, not an afterthought
- [**The moving parts**](the-moving-parts.md) —
  the helm program, charts, values,
  repositories and their indexes,
  releases, and which part holds what
- [**Installing Helm**](installing-helm.md) —
  the official release binary and its
  checksum, `helm version`, and the
  three folders Helm keeps its state in
- [**Your first chart**](your-first-chart.md) —
  `helm create` and the scaffold it
  writes, rendered and read before
  anything is changed
- [**Anatomy of a chart**](anatomy-of-a-chart.md) —
  a chart of this guide's own, file by
  file: Chart.yaml, values, templates,
  helpers, notes, and the schema
- [**Values and overrides**](values-and-overrides.md) —
  the values system: chart defaults,
  values files, `--set`, and the order
  they win in, proven with diffs
- [**Writing templates**](writing-templates.md) —
  the template language at work:
  pipelines, helpers, conditions, and
  the built-in objects every template
  can see
- [**Linting and debugging**](lint-and-debug.md) —
  `helm lint` passing clean and catching
  three real faults, and `--debug` for
  the renders Helm refuses to show you
- [**Packaging and versioning**](packaging-and-versioning.md) —
  `helm package`, the chart version
  versus the app version, and what ends
  up inside the archive
- [**Repositories**](repositories.md) —
  a chart repository is a folder and an
  index file: building one, serving it,
  and using it end to end
- [**Installing for real**](installing-for-real.md) —
  the cluster half, documented-only:
  install, upgrade, rollback, releases
  and their records, and exactly where
  this guide's evidence stops
- [**Recipes**](recipes.md) — render
  before you apply, one chart in three
  environments, examining a stranger's
  chart, sharing charts on a home
  network
- [**The neighbours**](the-neighbours.md) —
  raw manifests and kubectl, Kustomize,
  Compose, configuration managers and
  GitOps: what each does that Helm
  doesn't, and vice versa
- [**Limits**](limits.md) — a render is
  not an install, templates are code,
  values sprawl, and the rest of the
  fine print, stated plainly
- [**Troubleshooting**](troubleshooting.md) —
  the unreachable cluster, the function
  that does not exist, the schema's
  refusal, and the traps this guide's
  lab fell into so you don't have to
- [**Glossary**](glossary.md) — the
  terms, collected in one place

## What it doesn't cover

Running a cluster: this guide assumes
Kubernetes exists somewhere in your
life and teaches the packaging layer
only — the Kubernetes guide on this
shelf covers the cluster itself.
Operating a public chart repository as
a service, with accounts and signing
infrastructure, is pointed at, not
taught; the repository here is one
folder behind one small web server.
Writing charts for other people to
depend on at scale — API stability,
deprecation policy, testing fleets —
gets an honest paragraph, not a course.

## How to use this guide

Read chapter 1 for the model and the
trust rule, and chapter 2 before
installing anything — knowing which
part holds what turns later confusion
into a named problem. Chapters 4 to 10
are one continuous piece of work: the
lab chart grows, breaks, is packaged
and is published, and each chapter
checks its outcome before the next
begins. Do them in order, at a machine
with no cluster at all; nothing in them
needs one. Chapter 11 is the deliberate
change of register — read it to know
what will happen on a real cluster,
and notice how much of it chapter 4's
`--dry-run=client` already showed you.
The lab's chart lives in
`helm-lab/charts/hello/`; its
transcripts in `helm-lab/transcripts/`;
its notes are `examples/lab-notes.txt`.

---

## Part of the series

This guide is one of the [For Mere Mortals](https://paulsullivan33-dev.github.io/mere-mortals/) guides: plain-language guides to the tools programmers and makers use.

Related guides:

- [Kubernetes for Mere Mortals](https://paulsullivan33-dev.github.io/kubernetes-for-mere-mortals/)
- [K3s for Mere Mortals](https://paulsullivan33-dev.github.io/k3s-for-mere-mortals/)
- [K9s for Mere Mortals](https://paulsullivan33-dev.github.io/k9s-for-mere-mortals/)

## License

The writing in this guide is licensed under [CC BY 4.0](https://github.com/paulsullivan33-dev/helm-for-mere-mortals/blob/main/LICENSE). Code examples and lab scripts are licensed under the [MIT License](https://github.com/paulsullivan33-dev/helm-for-mere-mortals/blob/main/LICENSE-CODE).
