{{- /* vim: set filetype=mustache: */}}
{{- /*
Expand the name of the chart.
*/}}
{{- define "tyk-hybrid.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tyk-hybrid.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- /*
Create chart name and version as used by the chart label.
*/}}
{{- define "tyk-hybrid.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tyk-hybrid.gwproto" -}}
{{- if .Values.gateway.tls -}}
https
{{- else -}}
http
{{- end -}}
{{- end -}}

{{- define "tyk-hybrid.redis_url" -}}
{{- if .Values.redis.addrs -}}
{{ join "," .Values.redis.addrs }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.redis.host .Values.redis.port -}}
{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
redis.{{ .Release.Namespace }}.svc.cluster.local:6379
{{- end -}}
{{- end -}}
