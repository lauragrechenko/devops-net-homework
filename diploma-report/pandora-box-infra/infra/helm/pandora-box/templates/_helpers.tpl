{{- define "pandora-box.name" -}}
pandora-box
{{- end -}}

{{- define "pandora-box.labels" -}}
app: pandora-box
app.kubernetes.io/name: pandora-box
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "pandora-box.selectorLabels" -}}
app: pandora-box
{{- end -}}

{{- define "pandora-box.namespace" -}}
{{ .Values.namespace.name }}
{{- end -}}
