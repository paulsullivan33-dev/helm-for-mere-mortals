# Recipes

Outcome: the lab's techniques combined
into habits. Every recipe here is
local and was run in substance in
earlier chapters; the one that points
at a cluster says so.

## Render before you apply

Before any install or upgrade on a
real cluster (chapter 11, documented),
render the release locally and *read
it*:

```bash
helm template RELEASE CHART -f my-values.yaml > /tmp/render.yaml
helm install RELEASE CHART -f my-values.yaml --dry-run=client
```

The template output is the manifests;
the dry run adds the release header
and the notes. If a line in either
surprises you, the cluster should not
be the place you find out why. This
is the trust rule (chapter 1) as a
procedure, and it costs nothing —
which is exactly why skipping it is
so common and so regretted.

## One chart, three environments

Keep one values file per environment
beside the chart or in your own
repository:

```text
values.yaml          the defaults (chapter 5)
values-dev.yaml      1 replica, newest tag, chatty greeting
values-prod.yaml     the lab's busier site (chapter 6)
```

Installs name their layer:

```bash
helm template greetings ./charts/hello -f values-prod.yaml
```

The diff habit from chapter 6 scales
with it: render two environments and
diff them before a promotion, and the
question "what actually changes in
production?" has a five-line answer
instead of a hopeful one.

## Pin what you would grieve

Charts move; versions are how you
stand still on purpose:

```bash
helm pull lab/hello --version 0.1.0 -d dl
helm template greetings lab/hello --version 0.1.1
```

Pin the chart version in anything
automated. Pin the *image tag* in
values the same way (chapter 6's file
did, moving `1.27` to `1.28`
deliberately). An unpinned chart with
a floating tag is two surprises
waiting for the same morning.

## Examine a stranger's chart

Someone hands you a repository and a
name. In order, all local:

```bash
helm repo add them https://charts.example.test
helm repo update
helm show all them/their-chart      # metadata, values, readme
helm pull them/their-chart -d dl    # the archive, to read at leisure
helm template test them/their-chart > render.yaml
```

Then read `render.yaml` — all of it —
and the templates inside the pulled
archive for anything the render's
defaults kept switched off: an
`enabled: false` today is a `--set`
away from running tomorrow. Look for
accounts and roles with broad powers,
hooks that run unfamiliar images, and
anything that reaches outside the
release's namespace. Chapter 1's rule,
restated as a shopping habit: the
render is the contract; the rest is
sales material.

## Share charts on a home network

Chapter 10's repository was loopback
only because the lab's rules said so.
The same folder and index, served on
a small home server at an address
your machines can reach, is a working
chart repository for a whole house
fleet — rebuild the index with the
real `--url`, serve the folder, and
every machine `helm repo add`s the
same address. It is the cheapest
possible answer to "the chart is
finished, now get it onto the other
boxes", short of a public repository
you do not need.

## Keep renders under version control

A chart's most honest changelog is
its output. Render with committed
values files after each chart change
and diff the renders in review: a
template edit that was supposed to
touch one label and instead renamed
a Service is visible in a render diff
and nearly invisible in a template
diff. The lab did this by hand in
chapter 6; a script in a repository
does it without remembering to.

Check: each recipe stands on a
transcript you have already seen —
the diff (t04), the pinning and
pulling (t07, t08), the dry run
(t09), the shows (t08). Nothing here
needed a new claim, which is what
makes them recipes rather than
promises.
