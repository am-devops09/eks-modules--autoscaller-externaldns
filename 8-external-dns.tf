
# locals {
#   domain = "am-devops.com"
 
# }
# # External DNS IRSA
# module "external_dns_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.2.0" # Latest as of July 2022

#   role_name                     = "external-dns"
#   attach_external_dns_policy    = true
#   external_dns_hosted_zone_arns = ["arn:aws:route53:::hostedzone/Z06330162N1SM3PIHP6K9"] # am-devops HostedZone

#   oidc_providers = {
#     eks = {
#       provider_arn               = module.eks.oidc_provider_arn
#       namespace_service_accounts = ["kube-system:external-dns"]
#     }
#   }

# #   tags = "staging"
# }

# # External DNS
# resource "helm_release" "external_dns" {
#   name       = "external-dns"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "external-dns"

#   create_namespace = true
#   namespace        = "kube-system"

#   set {
#     name  = "wait-for"
#     value = module.external_dns_irsa_role.iam_role_arn
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com\\/role-arn"
#     value = module.external_dns_irsa_role.iam_role_arn
#   }

#   set {
#     name  = "domainFilters"
#     value = "{${local.domain}}"
#   }

#   set {
#     name  = "policy"
#     value = "sync"
#   }
  
#     set {
#     name  = "clusterName"
#     value = module.eks.cluster_id
#   }


  
#   }

# # NGINX Ingress Controller
# # resource "helm_release" "nginx" {
# #   name       = "nginx-ingress"
# #   repository = "https://helm.nginx.com/stable"
# #   chart      = "nginx-ingress"

# #   create_namespace = true
# #   namespace        = "nginx-ingress"
# # }

