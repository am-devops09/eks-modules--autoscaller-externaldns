variable "kube_monitoring_stack_values" {
  type    = string
  default = <<-EOF
    grafana:
      adminUser: admin
      adminPassword: admin
      enabled: true
      ingress:
        enabled: true
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/target-type: ip
          alb.ingress.kubernetes.io/group.name: monitoring-group
          alb.ingress.kubernetes.io/group.order: '1'
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
          alb.ingress.kubernetes.io/ssl-redirect: '443'
          alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:819401076850:certificate/43105b73-cfa5-4dcc-a66c-2e7a4dd62fe8
        hosts:
          - grafana.am-devops.com

    alertmanager:
      enabled: true
      ingress:
        enabled: true
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/target-type: ip
          alb.ingress.kubernetes.io/group.name: monitoring-group
          alb.ingress.kubernetes.io/group.order: '2'
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
          alb.ingress.kubernetes.io/ssl-redirect: '443'
          alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:819401076850:certificate/43105b73-cfa5-4dcc-a66c-2e7a4dd62fe8
        hosts:
          - alertmanager.am-devops.com
    prometheus:
      ingress:
        enabled: true
        ingressClassName: alb
        annotations:
          alb.ingress.kubernetes.io/scheme: internet-facing
          alb.ingress.kubernetes.io/target-type: ip
          alb.ingress.kubernetes.io/group.name: monitoring-group
          alb.ingress.kubernetes.io/group.order: '3'
          alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS":443}]'
          alb.ingress.kubernetes.io/ssl-redirect: '443'
          alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:819401076850:certificate/43105b73-cfa5-4dcc-a66c-2e7a4dd62fe8
        hosts:
          - prometheus.am-devops.com
      prometheusSpec:
        replicas: 2
        replicaExternalLabelName: prometheus_replica
        prometheusExternalLabelName: prometheus_cluster
        enableAdminAPI: false
        logFormat: logfmt
        logLevel: info
        retention: 120h
        serviceMonitorSelectorNilUsesHelmValues: false
        serviceMonitorNamespaceSelector: {}
        serviceMonitorSelector: {}
        resources:
          limits:
            memory: 2Gi
          requests:
            cpu: 500m
            memory: 2Gi

    prometheus-node-exporter:
      resources:
        limits:
          memory: 30Mi
        requests:
          cpu: 20m
          memory: 30Mi

    kube-state-metrics:
      resources:
        limits:
          memory: 300Mi
        requests:
          cpu: 10m
          memory: 300Mi

    prometheusOperator:
      resources:
        limits:
          memory: 400Mi
        requests:
          cpu: 10m
          memory: 400Mi
    EOF
}

resource "helm_release" "kube_monitoring_stack" {
  name       = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = "monitoring"
  version = "45.29.0"

  create_namespace = true

  values = [var.kube_monitoring_stack_values]
}