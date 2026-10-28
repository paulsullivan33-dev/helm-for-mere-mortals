# Troubleshooting

Outcome: the failures this guide's
lab actually produced, each with its
cause and its cure — plus the two
cluster-side failures the lab could
only document, marked as such.

## "Kubernetes cluster unreachable"

```text
Error: kubernetes cluster unreachable: Get "http://localhost:8080/version": dial tcp [::1]:8080: connect: connection refused
```

Any command that needs a cluster —
`helm list`, `install`, `upgrade` —
begins with a reachability check
(transcript `t09`). This message
means the check failed. Causes, in
order of likelihood: no kubeconfig
exists, so Helm tried its built-in
fallback address (the localhost:8080
in the message is that fallback
showing); the kubeconfig points at a
cluster that is stopped or on another
network; or the credentials in it are
expired. Fix the kubeconfig, not
Helm: `kubectl config current-context`
names the target every tool will use.

## `function "X" not defined`

```text
[ERROR] templates/: parse error at (hello/templates/service.yaml:8): function "shout" not defined
```

A template calls a function Helm does
not have — a typo, or a helper used
without being defined (transcript
`t05`). Read the error literally: file,
line, missing name. If the name is a
helper of yours, check `_helpers.tpl`
for the `define` — and check you are
looking at the chart you think you
are: the lab's error says
`hello/templates/...` even for its
broken copy, because Chart.yaml's
name, not the folder's, is what Helm
reports.

## "got string, want integer"

```text
[ERROR] values.yaml: - at '/replicaCount': got string, want integer
```

The chart's schema refused your
values (transcript `t05`). The fault
is in the values, not the chart: a
quoted number, a `--set` that
stringified, an environment file with
the wrong shape. The error names the
path in the values structure; fix
that leaf. If you are the chart's
author and the refusal surprised you,
your schema is stricter than your
documentation — loosen one of them.

## "YAML parse error" and the invisible render

```text
Error: YAML parse error on hello/templates/service.yaml: ... mapping values are not allowed in this context
```

The template rendered, but into
invalid YAML — most often an unquoted
value containing a colon, or a list
or map value arriving where a scalar
was drawn (transcript `t06b`). Helm
will not show you the bad output
without `--debug`; use it, find the
line the error names *in the render*
(the number refers to the rendered
document, not the template), and
then fix the template — usually a
`quote` (chapter 7) or a `toYaml`
for structured values.

## `helm pull` and the missing folder

```text
Error: open dl/hello-0.1.0.tgz...: no such file or directory
```

`helm pull -d FOLDER` does not create
FOLDER (transcript `t08`). `mkdir`
first. A small trap, preserved here
because the lab fell into it in front
of witnesses, and because "the tool
should have made the folder" is not
a cure.

## `helm repo add` that never answers

The lab's attempt to add a public
repository sat unanswered past ninety
seconds (transcript `t10`): a large
index on a slow or filtered network
looks exactly like a hang. Give it
time or fetch the index URL with
`curl` to see whether bytes move at
all; a repository that cannot be
fetched cannot be searched either —
the failure is connectivity, and
Helm's later errors will all be this
one wearing different coats. After a
successful add, `helm repo update`
that reports an error is the same
family: the index moved, shrank, or
the server went away.

## Two from the cluster side (documented)

These the lab could not run; they
are Helm's best-known bruises, from
its documentation and issue history,
included so a first real install is
not ambushed by them. A release stuck
in `pending-install` or `failed`
state blocks further operations on
that name until the state is dealt
with — `helm status` and `helm
history` tell the story, and chapter
11's record is where to read it. And
an upgrade that reports success
while a workload quietly fails to
become ready is what `--wait` and
`--atomic` exist for: the install
commands' promises are about
manifests accepted, not applications
healthy, unless you ask for the
stronger kind.
