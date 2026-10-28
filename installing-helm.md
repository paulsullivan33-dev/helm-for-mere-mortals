# Installing Helm

Outcome: `helm` on your machine, from
the project's own release, with the
download's checksum verified before
the program runs once — and a look at
where Helm keeps its state.

## The official binary

Helm publishes a ready-built program
for each operating system at
`helm.sh` (downloads are served from
`get.helm.sh`). The lab fetched the
Linux build of **Helm 4.3.1** and its
checksum file, and checked the one
against the other:

```bash
curl -LO https://get.helm.sh/helm-v4.3.1-linux-amd64.tar.gz
curl -LO https://get.helm.sh/helm-v4.3.1-linux-amd64.tar.gz.sha256sum
sha256sum -c helm-v4.3.1-linux-amd64.tar.gz.sha256sum
```

```text
helm-v4.3.1-linux-amd64.tar.gz: OK
```

The archive contains one folder with
the `helm` program (plus licence and
readme files). Unpack it and put the
program somewhere on your `PATH`:

```bash
tar -xzf helm-v4.3.1-linux-amd64.tar.gz
sudo cp linux-amd64/helm /usr/local/bin/
helm version
```

Check: the version prints, in the
long-winded default form and, with
`--short`, in one line — from the
lab's transcript
`helm-lab/transcripts/t00-version.txt`:

```text
$ helm version
version.BuildInfo{Version:"v4.3.1", GitCommit:"c0d08d0d6d9424d4a14febb5e8a3e51b0dd00dff", GitTreeState:"clean", GoVersion:"go1.27.2", KubeClientVersion:"v1.37"}

$ helm version --short
v4.3.1+gc0d08d0
```

Two other routes exist — an install
script served from the project's site,
and package managers (Homebrew, apt,
Chocolatey and friends), plus copies
bundled with desktop Kubernetes tools.
They are documented-only in this
guide: the lab verified the release
binary, and the script in particular
deserves the same suspicion as any
downloaded code — the checksum route
above is the one this guide can vouch
for, because it ran it.

## Where Helm keeps things

Helm needs no configuration to render
charts. For its own bookkeeping it
uses three folders, following the
usual per-user locations on each
platform:

- **config** — the repositories you
  have added, in `repositories.yaml`;
- **cache** — downloaded repository
  indexes and charts;
- **data** — anything else Helm
  stores.

`helm env` shows the whole
environment, paths included. The lab
pointed all three folders into its
scratch area with environment
variables, so nothing landed in the
machine's home folder — that is why
transcript `t00-version.txt` shows
paths under the lab. On your machine
the same command shows your real
defaults:

```bash
helm env | grep HOME
```

```text
HELM_CACHE_HOME="..."
HELM_CONFIG_HOME="..."
HELM_DATA_HOME="..."
```

You will meet the config folder again
in chapter 10, when `helm repo add`
writes to it, and the cache whenever
an index is refreshed.

## What Helm does not need

No cluster, no `kubectl`, no account
anywhere — for everything in chapters
4 to 10. Helm reaches for cluster
credentials only when a command asks
it to (chapter 11), using the standard
kubeconfig locations; until then the
program is a local tool, like a
compiler, and this guide treats it as
one.
