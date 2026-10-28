# Installing for Real

Outcome: you know exactly what
happens when a chart meets a cluster —
which parts this guide's lab watched
happen, which it could only show the
doorstep of, and how the cluster half
is organised. This is the guide's
documented-only chapter, and it says
so on its face: the lab had no
cluster. What is *run* here is real
(transcript `helm-lab/transcripts/t09-no-cluster.txt`);
what is *described* is from Helm's own
help and documentation.

## The doorstep, for real

Ask Helm to list releases on the lab
machine:

```text
$ helm list
Error: kubernetes cluster unreachable: Get "http://localhost:8080/version": dial tcp [::1]:8080: connect: connection refused
```

No kubeconfig exists on the machine,
so Helm falls back to a default
address — a cluster on localhost, port
8080 — finds nothing listening, and
says so. A real install starts the
same conversation and fails the same
way:

```text
$ helm install greetings ./charts/hello
Error: INSTALLATION FAILED: cluster reachability check failed: kubernetes cluster unreachable: ...
```

That reachability check is the exact
boundary of this guide's evidence, and
it is a genuinely useful thing to have
seen: before any manifest moves, Helm
must find a cluster and prove your
credentials work there. Everything
before the boundary — parsing,
merging values, schema checks,
rendering — happened identically on
the lab machine and happens
identically on yours.

## The one install that runs without a cluster

Helm 4's install has a client-only
dry run, and it is not a toy: it
renders the release exactly as an
install would, computes the notes,
and prints everything, while talking
to nobody:

```text
$ helm install greetings ./charts/hello --dry-run=client
NAME: greetings
LAST DEPLOYED: Wed Oct 28 11:59:58 2026
NAMESPACE: default
STATUS: pending-install
REVISION: 1
DESCRIPTION: Dry run complete
...
MANIFEST:
---
# Source: hello/templates/service.yaml
...

NOTES:
The hello server is installed as release "greetings".

Inside the cluster it answers on:
  http://greetings-hello:80/

It was started with this greeting:
  Hello from the hello chart
```

The transcript keeps the whole output.
Notice what the dry run shows that
`helm template` did not: the release
**header** a real install reports
(name, namespace, status, revision),
and the **NOTES** — chapter 5's
`NOTES.txt`, rendered and delivered.
The plain `--dry-run` flag is
deprecated in Helm 4 in favour of
spelling out `--dry-run=client` or
`--dry-run=server`; the server kind
performs the render *and* asks the
cluster to validate the manifests
without applying them — and on the
lab machine it fails at the same
reachability check as everything
cluster-bound, which the transcript
also keeps.

## What a real install does (documented)

Past the reachability check, an
install proceeds in a documented
order. Helm renders the chart with
the final merged values, sorts the
manifests into installation order by
kind (accounts and configuration
before workloads), runs any **hooks** —
templates annotated to fire at
lifecycle points such as before or
after the install, the mechanism
behind database migrations and the
scaffold's test pod — and sends the
manifests to the cluster's API. Then
it writes the **release record**: the
chart, the values as supplied, the
rendered manifests and the status,
stored in the cluster itself, by
default as a Secret in the release's
namespace named for the release and
revision. With `--wait`, Helm stays
until the workloads report ready;
with `--atomic`, a failed install
removes itself. The greeting notes
print last — the ones the dry run
showed you early.

## Upgrade, rollback, and the rest (documented)

The release record is why the rest of
Helm's verbs exist:

- **`helm upgrade RELEASE CHART`** —
  re-render with new values or a new
  chart version (install and upgrade
  combined in `helm upgrade --install`),
  compare the result with the recorded
  manifests, and apply the difference
  as a three-way merge: what the
  record says, what the cluster has,
  what the new render wants. The
  result is stored as the next
  **revision**.
- **`helm rollback RELEASE REVISION`** —
  re-apply an earlier revision's
  manifests as a new revision. A
  rollback is a copy forward, not a
  rewind of history; the failed
  revision stays in the record.
- **`helm history`, `helm status`,
  `helm get`** — read the record:
  revisions, status, the values a
  release *actually* runs with (`get
  values`), its manifests (`get
  manifest`), its notes (`get notes`).
  On a cluster you inherit, these are
  how you learn what is really there.
- **`helm uninstall RELEASE`** —
  delete the release's manifests in
  reverse order and, unless told to
  keep history, its record too.

Two honest consequences of the
design, documented and worth knowing
before you depend on either. First,
Helm manages what the record says:
a manifest edited by hand on the
cluster will drift, and an upgrade's
merge may restore, fight or trip over
the edit (chapter 14). Second, hooks
are not part of the release's managed
manifests in the ordinary way — they
fire and are largely left alone —
which surprises everyone exactly
once.

Check: you cannot check this chapter
against a cluster from the lab, and
the guide will not pretend otherwise.
You *can* reproduce the boundary:
`helm list`'s honest refusal, and the
client dry run's full picture of the
release you would have made. On a
machine with a cluster, the same
commands continue past the doorstep —
and chapter 12's first recipe is the
habit to carry there.
