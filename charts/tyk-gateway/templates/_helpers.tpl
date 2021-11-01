{{/*
Expand the name of the chart.
*/}}
{{- define "tyk-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tyk-gateway.fullname" -}}
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
{{- define "tyk-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- /* Create Semantic Version of gateway without prefix v */}}
{{- define "tyk-gateway.gateway-version" -}}
{{- printf "%s" .Values.image.tag | replace "v" "" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "tyk-gateway.labels" -}}
helm.sh/chart: {{ include "tyk-gateway.chart" . }}
{{ include "tyk-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "tyk-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "tyk-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
