# Packaging and Versioning

Outcome: the chart as a single,
versioned file another machine can
fetch — and a clear head about the
two version numbers travelling with
it.

## helm package

A chart folder is for authoring. For
distribution, Helm seals it:

```bash
helm package charts/hello -d pkg
```

```text
Successfully packaged chart and saved it to: pkg/hello-0.1.0.tgz
```

From transcript
`helm-lab/transcripts/t07-package.txt`.
The result is a gzipped tar archive
whose name is the chart name and
version joined. Everything in the
chart folder goes in, minus what
`.helmignore` excludes (the lab's
excludes archive files and editor
backups) — including, here, the extra
values file and the schema, which are
part of the chart's contract with its
users:

```text
$ tar -tzf pkg/hello-0.1.1.tgz
hello/Chart.yaml
hello/values.yaml
hello/values.schema.json
hello/templates/NOTES.txt
hello/templates/_helpers.tpl
hello/templates/deployment.yaml
hello/templates/ingress.yaml
hello/templates/service.yaml
hello/.helmignore
hello/values-prod.yaml
```

A packaged chart is what repositories
serve (chapter 10), what `helm pull`
fetches, and what an install from an
archive consumes. It is also a
commitment: an archive whose contents
change while its version does not is
a small betrayal of everyone who
fetched it, which is why the next
section exists.

## Two versions, two jobs

`Chart.yaml` carries `version` and
`appVersion`, and they answer
different questions:

- **`version`** is the chart's own
  version, in semantic versioning
  (`MAJOR.MINOR.PATCH`). Anything in
  the package changed — a template, a
  default, a comment a user relies
  on — the chart version moves. The
  lab changed nothing but the number
  itself to make the pair of archives
  below, and even that is a chart
  change:

  ```bash
  # Chart.yaml edited: version: 0.1.1
  helm package charts/hello -d pkg
  ```

  ```text
  Successfully packaged chart and saved it to: pkg/hello-0.1.1.tgz
  ```

- **`appVersion`** is the version of
  the application being installed —
  the server's release, not the
  packaging's. Charts conventionally
  use it as the default image tag;
  the scaffold does exactly that with
  an empty `image.tag` (chapter 4).
  The lab chart instead pins its tag
  in values, which is why its
  `appVersion: "1.0.0"` is a label of
  intent while `values-prod.yaml` can
  move the tag to `1.28` without
  touching Chart.yaml.

Repositories list chart versions;
clusters report chart versions in
every label (`helm.sh/chart:
hello-0.1.1`); upgrades (chapter 11)
are movements from one chart version
to another. Treat the number as part
of the chart's public surface, because
everyone downstream already does.

## Dependencies, at the depth this guide verifies

A chart may declare **dependencies** —
other charts it needs, listed in
Chart.yaml, fetched into its `charts/`
folder by `helm dependency update`,
and rendered as part of the parent.
The parent supplies their values under
the dependency's name in its own
values file; chapter 6's merge rules
are what make that work. The lab's
chart has no dependencies, so this
mechanism is documented-only here:
nothing in the transcripts fetches
one, and the guide does not dress the
description up as experience. Charts
built of other charts are common in
the wild — most large applications
are one — so the *reading* skill
matters even untried: when a render
shows resources your templates did
not write, they came from `charts/`,
and their values live one level down.

Signing and provenance — a `.prov`
file carrying a cryptographic
signature for an archive — exist and
are the grown-up answer to chapter
1's trust question for archives in
transit. They are likewise described,
not run, in this guide.

Check: `pkg/` holds two archives
differing only in Chart.yaml's
version, each listing the same ten
files. That pair is the input to
chapter 10 — a repository with
something real to serve.
