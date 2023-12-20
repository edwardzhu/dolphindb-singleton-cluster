{{- define "work.namespace" -}}
  {{ if .Values.global.allNamespace }}
  {{- printf "all" -}}
  {{- else -}}
  {{- printf "%s" .Release.Namespace -}}
  {{- end -}}
{{- end -}}

{{- define "maxPartitionNumPerQuery" -}}
{{- printf "%d" ( int .Values.global.maxPartitionNumPerQuery ) -}}
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

{{- define "cluster.config.volumes" -}}
{{- $numOfVolume := ( int .Values.agent.numberOfVolume ) -}}
{{- $volumes := list -}}
{{- $nodeIndex := .NodeIndex -}}
{{- range $i := until $numOfVolume -}}
{{- $volumes = (printf "/data/ddb/server/volumes/volume%d/datanode%d" $i $nodeIndex | append $volumes) -}}
{{- end -}}
{{- join "," $volumes -}}
{{- end -}}

{{- define "agent.maxMemSize" -}}
{{- print ( include "convertToGB" .Values.agent.resources.limits.memory ) -}}
{{- end -}}

{{- define "controller.maxMemSize" -}}
{{- print ( include "convertToGB" .Values.controller.resources.limits.memory ) -}}
{{- end -}}

{{- define "convertToGB" -}}
{{- $value := . -}}
{{- $num := regexFind "[0-9]+" $value -}}
{{- $unit := regexFind "[a-zA-Z]+" $value -}}
{{- $bytes := 0 -}}
{{- if eq $unit "K" -}}
{{- $bytes = mul (atoi $num) 0.000000931323 -}}
{{- else if eq $unit "Ki" -}}
{{- $bytes = mul (atoi $num) 0.000000953674752 -}}
{{- else if eq $unit "M" -}}
{{- $bytes = mul (atoi $num) 0.000931323 -}}
{{- else if eq $unit "Mi" -}}
{{- $bytes = mul (atoi $num) 0.0009765625 -}}
{{- else if eq $unit "G" -}}
{{- $bytes = mul (atoi $num) 0.9765625 -}}
{{- else if eq $unit "Gi" -}}
{{- $bytes = mul (atoi $num) 1 -}}
{{- else if eq $unit "T" -}}
{{- $bytes = mul (atoi $num) 931.323 -}}
{{- else if eq $unit "Ti" -}}
{{- $bytes = mul (atoi $num) 1024 -}}
{{- end -}}
{{- $bytes | int -}}
{{- end -}}