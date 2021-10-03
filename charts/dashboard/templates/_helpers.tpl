{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "dashboard.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "dashboard.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "dashboard.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "dashboard.labels" -}}
helm.sh/chart: {{ include "dashboard.chart" . }}
{{ include "dashboard.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/component: "tyk-dashboard"
{{- end }}

{{/*
Selector labels
*/}}
{{- define "dashboard.selectorLabels" -}}
app.kubernetes.io/name: {{ include "dashboard.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "dashboard.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "dashboard.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{- define "tyk-dashboard.proto" -}}
{{- if .Values.tls -}}
https
{{- else -}}
http
{{- end -}}
{{- end -}}


{{- define "tyk-dashboard.url" -}}
{{ include "tyk-dashboard.proto" . }}://{{ include "dashboard.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.dashboard.service.port }}
{{- end -}}


{{- define "tyk-dashboard.redis_url" -}}
{{- if .Values.redis.addrs -}}
{{ join "," .Values.redis.addrs }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.redis.host .Values.redis.port -}}
{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
redis.{{ .Release.Namespace }}.svc.cluster.local:6379
{{- end -}}
{{- end -}}


{{- define "tyk-dashboard.mongo_url" -}}
{{- if .Values.mongo.mongoURL -}}
{{ .Values.mongo.mongoURL }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.mongo.host .Values.mongo.port -}}
mongodb://{{ .Values.mongo.host }}:{{ .Values.mongo.port }}/tyk_analytics
{{- else -}}
mongodb://mongo.{{ .Release.Namespace }}.svc.cluster.local:27017/tyk_analytics
{{- end -}}
{{- end -}}
