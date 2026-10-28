# Glossary

**appVersion** — the version of the
application a chart installs, kept in
Chart.yaml separately from the chart's
own version (chapter 5).

**Built-in objects** — the data every
template can see: `.Values`,
`.Release`, `.Chart`, `.Capabilities`,
`.Files`, `.Template` (chapter 7).

**Capabilities** — what the cluster
claims to support, as templates see
it; filled with defaults when
rendering locally, which chapter 14
warns about.

**Chart** — a folder (or packaged
archive) of templates plus values
that installs one application
(chapter 2).

**Chart version** — the chart's own
semantic version in Chart.yaml,
distinct from appVersion (chapter 9).

**Dependency** — a chart another chart
needs, kept in its `charts/` folder
and configured from the parent's
values (chapter 9).

**Dry run, client** — `helm install
--dry-run=client`: the whole release
rendered and reported on your own
machine, cluster never contacted
(chapter 11).

**Dry run, server** — the render sent
to the cluster for validation but not
applied; needs a cluster (chapter 11).

**Helm** — the program this guide is
about: Kubernetes' package manager.

**Helper** — a named template fragment
defined in `_helpers.tpl` and reused
with `include` (chapter 7).

**Hook** — a template annotated to run
at a lifecycle point (before an
install, as a test, and so on) rather
than as part of the steady-state
release (chapter 11).

**Index** — `index.yaml`, the file
that makes a web server a chart
repository: every chart, version, URL
and digest (chapter 10).

**Kubeconfig** — the file holding
cluster addresses and credentials that
Helm and kubectl share.

**Library chart** — a chart of type
`library`: fragments for other charts,
installs nothing itself (chapter 5).

**Lint** — `helm lint`: render a chart
with its defaults and report faults
before anyone installs it (chapter 8).

**Manifest** — one YAML document
describing one Kubernetes object.

**NOTES.txt** — the template rendered
after an install, as a message to the
human who ran it (chapter 5).

**OCI registry** — a container-image
store also usable for charts,
addressed with `oci://` references
(chapter 10).

**Package** — `helm package`'s output:
one versioned `.tgz` archive of a
chart (chapter 9).

**Pipeline** — a template expression
flowing a value through functions,
left to right (chapter 7).

**Provenance** — a signature file
(`.prov`) accompanying a packaged
chart; described, not run, in this
guide (chapter 9).

**Release** — one installation of a
chart into a cluster: its name,
values, manifests and record
(chapters 1 and 11).

**Release record** — the cluster-side
record of a release, stored by
default as Secrets in its namespace,
one per revision (chapter 11).

**Repository** — a web server serving
packaged charts and an index
(chapter 10).

**Revision** — the numbered version
of a release: install is revision 1,
each upgrade and rollback adds one
(chapter 11).

**Rollback** — `helm rollback`:
re-apply an earlier revision's
manifests as a new revision
(chapter 11).

**Schema** — `values.schema.json`, the
rules a chart's values must obey,
checked before rendering (chapters 5
and 8).

**Template** — a manifest with
`{{ ... }}` instructions mixed in,
or the language they are written in.

**Values** — the settings a chart
exposes, merged from defaults, files
and `--set` in that order of strength
(chapter 6).
