# Repositories

Outcome: a working chart repository
built from a folder and a small web
server, used end to end — added,
searched, inspected, pulled from and
rendered from — which is all a
repository has ever been.

## What a repository is

Strip the word of ceremony: a chart
repository is a web server that can
serve two kinds of file — packaged
charts (chapter 9's archives), and one
index. The index, `index.yaml`, lists
every chart and version the server
holds, with the archive's URL and its
SHA-256 digest. Clients never browse;
they fetch the index, read it, and
download archives by address, checking
each against its digest. (That digest
check is worth pausing on: a fetched
chart is verified against the index's
sum automatically. It proves the
archive matches the index — not that
either deserves your trust. Chapter 1
still applies.)

## Building the index

```bash
helm repo index charts-repo --url http://127.0.0.1:18099
```

run over a folder holding the lab's
two archives, writes `index.yaml`
beside them. The lab's index (kept in
this repository as
`helm-lab/charts-repo-index.yaml`)
says, in its own words:

```yaml
apiVersion: v1
entries:
  hello:
  - apiVersion: v2
    appVersion: 1.0.0
    created: "2026-10-28T11:59:30.523056889Z"
    description: A tiny web server, packaged as a chart to learn Helm with
    digest: 19f7ab680e0b4b193756ae77541502617ee20be201b5abad1344e30ee76e4c2b
    name: hello
    type: application
    urls:
    - http://127.0.0.1:18099/hello-0.1.1.tgz
    version: 0.1.1
  - ...
    version: 0.1.0
```

The `--url` becomes the prefix of
every archive address in the index,
so the index must be built knowing
where it will be served from. Any
plain web server then *is* a chart
repository; the lab served the folder
with Python's built-in server on
loopback, port 18099:

```bash
python3 -m http.server 18099 --directory charts-repo
```

and `curl` confirmed the index answers
before Helm was told about it.

## Using it

From transcript
`helm-lab/transcripts/t08-local-repo.txt`,
the whole client story:

```bash
helm repo add lab http://127.0.0.1:18099
```

```text
"lab" has been added to your repositories
```

`repo add` fetches the index once, to
be sure the address is real, and
records the pair (name, URL) in the
config folder from chapter 3. From
then on:

```text
$ helm search repo hello
NAME        CHART VERSION  APP VERSION  DESCRIPTION
lab/hello   0.1.1          1.0.0        A tiny web server, packaged as a chart to learn...

$ helm search repo lab/hello --versions
NAME        CHART VERSION  APP VERSION  DESCRIPTION
lab/hello   0.1.1          1.0.0        A tiny web server, packaged as a chart to learn...
lab/hello   0.1.0          1.0.0        A tiny web server, packaged as a chart to learn...

$ helm show chart lab/hello
apiVersion: v2
appVersion: 1.0.0
description: A tiny web server, packaged as a chart to learn Helm with
name: hello
type: application
version: 0.1.1
```

`helm show` is the trust rule's best
friend: `show chart`, `show values`,
`show readme` and `show all` read a
chart from a repository without
installing — or even downloading
beyond the reading of it. Search
shows the newest version by default;
`--versions` shows the shelf.

Fetching and using follow the same
shape:

```bash
mkdir dl
helm pull lab/hello --version 0.1.0 -d dl
helm template greetings lab/hello --version 0.1.1
```

`helm pull` downloads the archive —
note `mkdir` first: the lab's first
pull failed with `no such file or
directory` because the destination
folder did not exist (chapter 15 keeps
the bruise). And `helm template`
accepts a repository reference exactly
as it accepts a folder: the render
arrives with the same two documents,
sourced from the archive this time.
`helm repo update` refreshes indexes;
`helm repo remove lab` forgets the
whole thing. The lab's server was
then stopped, and the port checked
empty.

## Other people's repositories

Public repositories are this, at
scale: the same index and archives,
served by a project or a company.
Adding one is one command, and
chapter 12's recipe for examining a
stranger's chart starts there. The
lab attempted to add the Prometheus
community repository as a bonus; the
index download did not complete
within ninety seconds on the lab's
network (transcript `t10`), so nothing
in this guide rests on it — the local
repository above exercises every
client command there is.

Charts are also published through
**OCI registries** — the stores built
for container images — addressed as
`oci://` references, pushed and
pulled rather than indexed. That
route is documented-only in this
guide: rising in popularity, identical
in trust questions, different in
plumbing.

Check: a repository you can rebuild
from the chapter — folder, archives,
index, server — and a client that
searched it, read from it, pulled an
older version out of it, and rendered
the newest without any cluster
existing. Distribution was the last
local piece; chapter 11 crosses to
the cluster, honestly labelled.
