# Values and Overrides

Outcome: the same chart, rendered
three ways, with the differences
counted on your fingers — and the
precedence rules that decide which
setting wins when several speak at
once.

A chart's `values.yaml` is its
defaults, not its destiny. The person
installing the chart supplies their
own values in layers, and Helm merges
them into one final set before a
single template runs. The layers, from
weakest to strongest:

1. the chart's own `values.yaml`;
2. values files given with `-f`, in
   order — a later file beats an
   earlier one;
3. individual settings given with
   `--set` (and its cousins
   `--set-string` and `--set-file`).

Merging is by key, and it is kind to
structure: overriding `image.tag`
leaves `image.repository` at its
default, because the merge happens
key by key, not file by file.

## A second values file

The lab keeps a second file beside the
chart, `values-prod.yaml`, describing
the same web server at a busier
fictional site: three replicas instead
of one, a newer image tag, a `NodePort`
service on port 8080, a new greeting.
Rendering both ways and diffing the
results is the whole lesson — from
transcript `helm-lab/transcripts/t04-values-overrides.txt`:

```bash
helm template greetings ./charts/hello > render-default.yaml
helm template greetings ./charts/hello -f charts/hello/values-prod.yaml > render-prod.yaml
diff render-default.yaml render-prod.yaml
```

```text
13c13
<   type: ClusterIP
---
>   type: NodePort
15c15
<     - port: 80
---
>     - port: 8080
35c35
<   replicas: 1
---
>   replicas: 3
48c48
<           image: "nginx:1.27"
---
>           image: "nginx:1.28"
52c52
<               value: "Hello from the hello chart"
---
>               value: "Hello from the busy site"
```

Five lines. Everything the second
site changed, and nothing it did not.
This is the values system keeping its
promise: the chart stayed untouched,
and the difference between two
installations of the same application
fits in a diff you can read aloud.
(Keep this trick; chapter 12 makes a
recipe of it.)

## --set, the strongest layer

For a single setting, a file is
ceremony. `--set` overrides from the
command line:

```bash
helm template greetings ./charts/hello \
  --set replicaCount=5 --set message="Set beats file"
```

```text
  replicas: 5
              value: "Set beats file"
```

And layered over the file, `--set`
still wins — the precedence list above
is not a slogan:

```bash
helm template greetings ./charts/hello \
  -f charts/hello/values-prod.yaml --set replicaCount=5 \
  | grep "replicas:"
```

```text
  replicas: 5
```

Practical notes the lab relied on:
`--set` reads values as YAML-ish
scalars, so numbers arrive as numbers
and `true` as a boolean; use
`--set-string` when a value must stay
a string (a tag like `1.0` that would
otherwise become a number is the
classic case), and commas inside a
`--set` value need escaping as `\,`,
since commas separate settings.

## Switches are values too

Recall the Ingress that renders to
nothing. It is not a special feature;
it is an ordinary boolean doing its
job:

```bash
helm template greetings ./charts/hello \
  --set ingress.enabled=true | grep -A3 "kind: Ingress"
```

```text
kind: Ingress
metadata:
  name: greetings-hello
```

Optional pieces of real charts — a
database here, monitoring there — are
nearly always this same pattern:
an `enabled` value, an `if` in the
template, nothing rendered when off.

Check: render the lab chart the three
ways and reproduce the five-line diff.
When you can point at the exact line
each layer changed, the values system
holds no more surprises — only, in
chapter 14's phrase, the sprawl that
success brings.
