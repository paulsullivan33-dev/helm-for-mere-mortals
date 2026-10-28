# Writing criteria for this guide

Every "for Mere Mortals" guide is written to the same nine-point
standard, so a reader who trusts one can trust the rest. Here it
is, with the verification notes for this particular guide below.

1. **Fix it first.** Reader outcomes lead, not action items: each
   chapter opens by naming the outcome it delivers, shows a check
   the reader can run to confirm they got it, and a reasonable
   reader finishes able to state what was done, what it means,
   and what to try next.
2. **Plain language.** Short sentences, everyday vocabulary,
   technical terms defined on first use. No slang, and no
   idioms that only make sense in one country — the reader may
   be translating as they go.
3. **No dead ends.** A guide never tells the reader to do
   something it cannot show them how to verify. Every claim a
   reader relies on — an install, a command, an output — is
   something this guide demonstrates or clearly labels
   documented-only below.
4. **Live-verified where it matters.** Procedures are run for
   real in the guide's lab wherever the build machine allows it,
   and the transcripts kept in the repository are the evidence.
   What could not be run is listed honestly below, never
   presented as if it had been.
5. **General audiences.** Nothing in this guide — examples,
   fixtures, names, addresses — is modelled on any particular
   reader or author's real life, network, or organisations.
   The lab's traffic is the lab talking to itself.
6. **Standalone.** A reader needs this guide, its lab, and
   nothing else. Where another guide would genuinely help, it
   is pointed to once, by name, and the chapter still completes
   without it.
7. **Honest about limits.** Chapter 14 names what the tool
   cannot do: a render that no real API server has checked,
   templates as code that can fail and mislead, values sprawl,
   charts of uneven quality, drift between a release's record
   and a cluster edited by hand, and the trust a chart asks
   of whoever installs it.
8. **The trust rule is in the text, early.** Chapter 1 and the
   README state the rule plainly — *read a chart before you
   install it, and only ever install onto clusters that are
   yours to change* — before any procedure depends on it, and
   later chapters point back to it where the tooling would
   make skipping the reading easy.
9. **Builds clean.** The site builds with MkDocs in strict mode
   with no warnings, and a fresh reader following the chapters
   in order reaches the stated outcome of each.

## Verification notes for this guide

The build machine is a 2-CPU, 7.7 GB Ubuntu 24.04 sandbox with
no Kubernetes cluster and no kubectl. Helm **4.3.1** was the
official release binary from helm.sh, its SHA-256 verified
against the project's published checksum before it was run
once. Helm's cache, config and data folders were pointed into
the lab's scratch area with the `HELM_CACHE_HOME`,
`HELM_CONFIG_HOME` and `HELM_DATA_HOME` environment variables,
so the run left nothing in the machine's real home folder. All
transcripts live in `helm-lab/transcripts/`; the chart the lab
wrote is `helm-lab/charts/hello/`.

Run for real, with transcripts as evidence:

- Install and version, and Helm's state folders read back with
  `helm env` (t00).
- The scaffold: `helm create demo`, its file tree and its
  Chart.yaml, and the scaffold rendered with `helm template`,
  including `--show-only` for one file (t01, t02).
- The lab's own chart, linted clean and rendered under the
  release name `greetings` (t03).
- Values overrides proven with diffs: a second values file
  changed exactly five rendered lines; `--set` beat the file,
  and the file beat the chart's defaults; an optional Ingress
  rendered only when a value asked for it (t04).
- Lint and template failures, each with its error text and
  exit code: a template function that does not exist, a value
  of the wrong type refused by the chart's own
  `values.schema.json`, and a template's `required` refusing
  an empty greeting (t05). A render whose output was not
  valid YAML, shown raw with `--debug` (t06, t06b).
- Packaging at chart versions 0.1.0 and 0.1.1, and the
  archive's contents listed (t07).
- A local chart repository end to end: `helm repo index`
  over the packaged charts, the folder served over HTTP by a
  small Python web server on loopback, then `helm repo add`,
  `helm search repo`, `helm show chart`, `helm pull` (which
  first failed, genuinely, because its destination folder
  did not exist), `helm template` straight from the
  repository, `helm repo update` and `helm repo remove`
  (t08). The server was stopped afterwards and the port
  checked empty.
- The cluster boundary, run into deliberately: `helm list`
  and `helm install` answering "Kubernetes cluster
  unreachable", `helm install --dry-run=server` failing the
  same way, and `helm install --dry-run=client` succeeding
  entirely locally — full manifest and NOTES output (t09).

Documented only — described from the project's documentation,
not run, and the text does not claim otherwise:

- Everything that happens on a real cluster: `helm install`
  applying manifests, upgrades and their three-way merge,
  rollbacks, `helm uninstall`, `helm list` and `helm status`
  against a live cluster, release records stored as Secrets,
  `--wait` and `--atomic`, and hooks firing at their lifecycle
  points. Chapter 11 teaches this half from Helm's help and
  docs, with the lab's transcripts showing exactly where the
  local evidence ends.
- Installing Helm by the install script, by package managers,
  or from source (chapter 3 verifies the release binary).
- OCI registries as chart stores; the lab's repository is the
  classic HTTP kind, run end to end.
- A public chart repository: `helm repo add` for the
  Prometheus community repository was attempted and the
  index download did not complete within ninety seconds on
  the lab's network (t10). Nothing in chapter 10 depends on
  it.
- Chart signing and provenance verification, dependency
  charts vendored from public repositories, and library
  charts beyond a description.

Fixtures are this guide's own and deliberately generic: a
scaffold chart generated by the tool itself, a nine-file
chart for a tiny fictional web server whose only job is to be
readable, and a second values file describing a busier site
that does not exist. No example is modelled on any real
person, organisation, service or cluster, and nothing was
installed anywhere: every render in this guide happened on
the machine that wrote it.
