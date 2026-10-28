# The Neighbours

Outcome: Helm placed among the tools
that overlap it, so choosing it — or
not — is a decision rather than a
default. These are characterisations,
not benchmarks; each tool deserves
its own shelf-guide, and several
already have one.

## kubectl and plain manifests

The floor everything stands on: YAML
files applied with `kubectl apply`.
No merging, no values, no release
record — the file is the whole story.
For one application at one site this
is not a compromise but the honest
minimum, and many Helm charts are
adopted only when the second site
arrives. Plain manifests also never
surprise you at render time, because
there is no render.

## Kustomize

Kubernetes' built-in answer to the
same problem, with the opposite
temperament: a base set of manifests
plus **overlays** that patch it per
environment — change this image, add
that label — without a template
language at all. Where Helm generates
YAML with code, Kustomize edits YAML
with patches. Teams that distrust
templating (chapter 14 gives their
reasons) often land here; teams that
need packaging and versioning of the
kind chapter 10 showed usually land
on Helm. The two also compose: some
charts are consumed as Kustomize
bases, and some Helm users render
first and patch after.

## Docker Compose

One machine, one file, services
declared and run — for development
and small single-host deployments it
is the friendlier tool, and it does
not pretend to be a cluster. If your
application fits on one box, Compose
is probably the right answer and a
chart is ceremony. (The shelf has a
Docker Compose guide; it is the
natural prequel for readers who have
not met either.)

## Configuration managers and infrastructure tools

Ansible, and Terraform and its kin,
answer a bigger question — whole
machines, whole estates — and both
can drive Kubernetes among their many
targets. What they do not centre on
is the application-as-package: the
versioned chart, the repository, the
rollback. Estates usually run both
kinds of tool, each at its own layer.
The shelf's Ansible and Terraform
guides cover those layers directly.

## GitOps controllers

Argo CD and Flux watch a git
repository and keep a cluster matching
it — releases without a human running
`helm upgrade`. Helm charts are one
of their favourite inputs: the chart
supplies the packaging, the controller
supplies the vigilance, and chapter
11's upgrade becomes a commit. The
shelf's Argo CD guide treats that
workflow in full; nothing here
competes with it.

## K9s and the watching tools

Once releases exist, they must be
watched: K9s (its guide is a sibling
of this one) shows workloads and
their state in a terminal, and the
release's objects carry Helm's labels
(chapter 4), which is how a watcher
knows a Deployment belongs to a
release rather than to nobody. Helm
makes and changes things; it is a
poor window, and it does not try to
be one.

Check: for each neighbour you can
now name the question it answers
better than Helm — and the question
Helm answers better than it. That is
the whole content of tool loyalty,
usefully understood.
