{{- /* vim: set filetype=mustache: */}}
{{- /*
Expand the name of the chart.
*/}}
{{- define "tyk-headless.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "tyk-headless.fullname" -}}
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
{{- define "tyk-headless.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Create Semantic Version of gateway without prefix v */}}
{{- define "tyk-headless.gateway-version" -}}
{{- printf "%s" .Values.gateway.image.tag | replace "v" "" -}}
{{- end -}}

{{- define "tyk-headless.redis_url" -}}
{{- if .Values.redis -}}
{{- if .Values.redis.addrs -}}
{{ join "," .Values.redis.addrs }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.redis.host .Values.redis.port -}}
{{ .Values.redis.host }}:{{ .Values.redis.port }}
{{- else -}}
redis.{{ .Release.Namespace }}.svc.cluster.local:6379
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "tyk-headless.mongo_url" -}}
{{- if .Values.mongo -}}
{{- if .Values.mongo.mongoURL -}}
{{ .Values.mongo.mongoURL }}
{{- /* Adds support for older charts with the host and port options */}}
{{- else if and .Values.mongo.host .Values.mongo.port -}}
mongodb://{{ .Values.mongo.host }}:{{ .Values.mongo.port }}/tyk_analytics
{{- else -}}
mongodb://mongo.{{ .Release.Namespace }}.svc.cluster.local:27017/tyk_analytics
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "tyk-headless.pg_connection_string" -}}
{{- if .Values.postgres -}}
{{- range $key, $value := .Values.postgres }}{{ print $key "=" $value " " }}{{- end }}
{{- end -}}
{{- end -}}

{{- define "tyk-headless.backend" -}}
{{- if .Values.backend -}}
{{- if eq "postgres" .Values.backend -}}
postgres
{{- else if eq "mongo" .Values.backend -}}
mongo
{{- end -}}
{{- else if .Values.mongo.enabled -}}
mongo
{{- else -}}
none
{{- end -}}
{{- end -}}

{{- define "tyk-headless.tplvalues.render" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
