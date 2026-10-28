{{/*
The chart's short name. Used for resources that do not need the
release name in them.
*/}}
{{- define "hello.name" -}}
{{- .Chart.Name }}
{{- end }}

{{/*
The full name of a release of this chart: the release name and
the chart name together, so two releases never collide.
*/}}
{{- define "hello.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}

{{/*
Labels every resource from this chart carries.
*/}}
{{- define "hello.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version }}
app.kubernetes.io/name: {{ include "hello.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Labels that select this release's pods. These must stay stable:
a Deployment's selector cannot change after creation.
*/}}
{{- define "hello.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hello.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
