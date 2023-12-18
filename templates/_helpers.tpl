{{- define "work.namespace" -}}
  {{ if .Values.global.allNamespace }}
  {{- printf "all" -}}
  {{- else -}}
  {{- printf "%s" .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "global.service.type" -}}
{{- .Values.global.serviceType | default "NodePort" -}}
{{- end -}}

{{- define "dolphindb.service.type" -}}
{{- .Values.dolphindb.serviceType | default (include "global.service.type" . ) -}}
{{- end -}}

{{- define "statefulset.name" -}}
  {{ if .Values.global.serviceName }}
  {{- printf "%s" .Values.global.serviceName -}}
  {{- else -}}
  {{- printf "%s-%s" "dolphindb-singleton" ( include "work.namespace" . ) -}}
  {{- end -}}
{{- end -}}

{{- define "repository" -}}
    {{- $registry := .Values.global.registry -}}
    {{ if $registry }}
    {{- printf "%s/%s" $registry .Values.global.repository -}}
    {{- else -}}
    {{- printf "%s" .Values.global.repository -}}
    {{- end -}}
{{- end -}}

{{- define "imageTag" -}}
{{- printf "%s/dolphindb:%s" ( include "repository" . ) ( default "latest" .Values.dolphindb.imageTags ) -}}
{{- end -}}

{{- define "controller.workerNum" -}}
{{ max ( .Values.controller.resources.limits.cpu ) 1 }}
{{- end -}}

{{- define "configLoader.image" -}}
{{- printf "%s/dolphindb-config-loader:%s" ( include "repository" . ) ( default "latest" .Values.dolphindbConfigLoader.imageTags ) -}}
{{- end -}}

{{- define "controller.serviceType" -}}
{{ if .Values.controller.serviceType }}
{{- printf .Values.controller.serviceType -}}
{{- else -}}
{{- printf .Values.global.serviceType -}}
{{- end -}}
{{- end -}}