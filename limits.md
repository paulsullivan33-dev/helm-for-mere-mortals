# Limits

What Helm cannot do, and what it must
not be asked to pretend — the chapter
the rest of the guide has been
promising.

## A render is not an install

`helm template` proves that templates
and values combine into well-formed
YAML. It does not prove a cluster
will accept the result. Kinds the API
server does not know (missing CRDs),
versions the cluster dropped,
admission policies that refuse the
shape, quotas with no room — all live
past the reachability check the lab
ran into in chapter 11. Even
`--dry-run=server`, which asks the
cluster to validate without applying,
cannot promise that the real apply
will succeed later. Relatedly,
`.Capabilities` is filled with
defaults during local rendering, so
a template that branches on the
cluster's version or APIs can render
one way on your desk and another on
install. Treat every local render as
a strong draft, not a guarantee.

## Templates are code

A chart's templates are programs, and
they inherit the family traits:
indentation errors that render into
valid-looking YAML, helpers whose
names promise more than they do,
logic that only fails for values
nobody tested. Helm's tools catch
what they can — chapter 8's three
confessions are real — but there is
no type system standing between a
determined chart author and a subtle
wrongness, and large charts can be
genuinely hard to read. This is the
substance behind Kustomize's appeal
(chapter 13) and behind the reading
habit in chapter 12. The lab chart
also took one deliberate shortcut of
its own — it skipped the scaffold's
name-truncation armour — which is the
right place to confess that teaching
charts, including this one, simplify.

## Values sprawl

Success makes values grow. A chart
used at ten sites accretes a setting
for every site's oddity until the
values file is a language of its own
and most combinations have never been
rendered, let alone run. The schema
(chapter 5) fences types and ranges;
it cannot fence combinations, and no
tool in this guide tests them for
you. The defences are habits: render
in review (chapter 12), keep
per-environment files small and
legible, and delete settings whose
moment has passed.

## Drift

A release record describes the
cluster as Helm left it. Clusters do
not stay as they were left: a
teammate's `kubectl edit`, an
operator reconciling its own objects,
an autoscaler doing its job. Helm's
upgrades merge against the record,
not against the truth, and may revert
a deliberate hand-edit or fail
against an undeliberate one. The
record is a memory, not a watcher;
GitOps controllers (chapter 13)
exist precisely to close that gap.

## The trust, once more

Charts ask a lot: applied with your
credentials, hooks running arbitrary
images at lifecycle moments,
templates able to produce cluster-wide
objects from an innocent-looking
chart. The index digest proves an
archive matches its index; it does
not grade the contents. Provenance
signing exists and is widely unused.
Which returns the guide to chapter
1, as promised: the render is the
only audit that always works, and it
works only if someone reads it.

## This guide's own limit

Helm's cluster half — upgrades and
their merges, rollbacks, hooks
firing, records ageing in real
namespaces — is described here from
documentation because the lab had no
cluster. The descriptions are Helm's
own account of itself, and real
clusters have opinions documentation
does not capture. Where the two might
differ, believe the cluster, and
extend the same courtesy to this
guide that chapter 8 taught you to
extend to charts: it showed you its
evidence, and named what it could not
show.
