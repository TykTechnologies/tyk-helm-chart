{{- /* vim: set filetype=mustache: */}}
{{- /*
Expand the name of the chart.
*/}}
{{- define "tyk-pro.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tyk-pro.fullname" -}}
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
{{- define "tyk-pro.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "tyk-pro.gwproto" -}}
{{- if .Values.gateway.tls -}}
https
{{- else -}}
http
{{- end -}}
{{- end -}}

{{- define "tyk-pro.dash_proto" -}}
{{- if .Values.dash.tls -}}
https
{{- else -}}
http
{{- end -}}
{{- end -}}

{{- define "tyk-pro.dash_url" -}}
{{ include "tyk-pro.dash_proto" . }}://dashboard-svc-{{ include "tyk-pro.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.dash.service.port }}
{{- end -}}

{{- define "tyk-pro.gateway_url" -}}
{{ include "tyk-pro.gwproto" . }}://gateway-svc-{{ include "tyk-pro.fullname" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.gateway.service.port }}
{{- end -}}

{{- define "tyk-pro.redis_url" -}}
{{- if .Values.redis.addrs -}}
{{ join "," .Values.redis.addrs }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.redis.host .Values.redis.port -}}
{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
redis.{{ .Release.Namespace }}.svc.cluster.local:6379
{{- end -}}
{{- end -}}

{{- define "tyk-pro.mongo_url" -}}
{{- if .Values.mongo.mongoURL -}}
{{ .Values.mongo.mongoURL }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.mongo.host .Values.mongo.port -}}
mongodb://{{ .Values.mongo.host }}:{{ .Values.mongo.port }}/tyk_analytics
{{- else -}}
mongodb://mongo.{{ .Release.Namespace }}.svc.cluster.local:27017/tyk_analytics
{{- end -}}
{{- end -}}

{{- define "tyk-pro.pg_connection_string" -}}
{{- if .Values.postgres -}}
{{- range $key, $value := .Values.postgres }}{{ print $key "=" $value " " }}{{- end }}
{{- end -}}
{{- end -}}

{{- define "tyk-pro.backend" -}}
{{- if .Values.backend -}}
{{- if eq "postgres" .Values.backend -}}
postgres
{{- else if eq "mongo" .Values.backend -}}
mongo
{{- end -}}
{{- else -}}
mongo
{{- end -}}
{{- end -}}


{{- /* Create Semantic Version of gateway without prefix v */}}
{{- define "tyk-pro.gateway-version" -}}
{{- printf "%s" .Values.gateway.image.tag | replace "v" "" -}}
{{- end -}}
