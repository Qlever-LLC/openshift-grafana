{{/* vim: set ft=helm : */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "openshift-grafana.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "openshift-grafana.fullname" -}}
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
{{- define "openshift-grafana.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "openshift-grafana.labels" -}}
helm.sh/chart: {{ include "openshift-grafana.chart" . }}
{{ include "openshift-grafana.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "openshift-grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ include "openshift-grafana.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "openshift-grafana.serviceAccountName" -}}
{{- printf "%s-sa" (include "openshift-grafana.fullname" .) }}
{{- end }}

{{- define "openshift-grafana.domain" -}}
{{- if .Values.domain | empty }}
{{- lookup "config.openshift.io/v1" "Ingress" "" "cluster" | dig "spec" "domain" "" }}
{{- else }}
{{- .Values.domain }}
{{- end }}
{{- end }}

{{- define "openshift-grafana.route" -}}
{{- printf "%s-route-%s" (include "openshift-grafana.fullname" .) .Release.Namespace }}
{{- end }}

{{- define "openshift-grafana.url" -}}
{{- printf "https://%s.%s" (include "openshift-grafana.route" .) (include "openshift-grafana.domain"  .) }}
{{- end }}