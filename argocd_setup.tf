
# creating argocd namepsace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = "argocd"
  }
  # depends_on = [module.eks]
}

#installing argocd helm chart
resource "helm_release" "argocd" {
  depends_on = [kubernetes_namespace.argocd]

  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "7.4.2"

values = [
  file("${path.module}/argo/argocd_values.yaml")
]
timeout = 600  # Increase timeout to 10 minutes
}

# resource "kubectl_manifest" "argo_addon_project" {
#   depends_on = [helm_release.argocd, kubernetes_secret.addon_repo_secret]
#   yaml_body  = file("./argo/argo_addon_project.yaml")
# }

# data "aws_secretsmanager_secret_version" "github_pat_secret" {
#   secret_id = "ARGOCD_APP_SOURCE_GITHUB_PAT" # Replace with the name or ARN of your secret
# }

# resource "kubernetes_secret" "addon_repo_secret" {
#   # depends_on = [module.eks]
#   metadata {
#     name      = "helm-repo-secret"
#     namespace = "argocd"
#     labels = {
#       "argocd.argoproj.io/secret-type" = "repository"
#     }
#   }

#   type = "Opaque"

#   data = {
#     url : "https://github.com/<repo_name>/argocd-manifests.git"
#     password : jsondecode(data.aws_secretsmanager_secret_version.github_pat_secret.secret_string)["GITHUB_PAT"]
#     username : "devops"
#     project = "addon-apps"
#   }
# }

# resource "kubernetes_manifest" "argo_addon_parent_app" {
#   depends_on = [helm_release.argocd]
#   manifest = yamldecode(file("${path.module}/argo/custom_plugins_parent_apps.yaml"))
# }
