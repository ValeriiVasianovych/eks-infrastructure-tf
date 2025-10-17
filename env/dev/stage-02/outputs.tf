# output "manager_access_key_id" {
#   value       = nonsensitive(module.access-management.manager_access_key_id)
#   description = "The access key ID for the manager user"
# }

# output "manager_secret_access_key" {
#   value       = nonsensitive(module.access-management.manager_secret_access_key)
#   description = "The secret access key for the manager user"
# }

# output "readonly_user_access_key_id" {
#   value       = nonsensitive(module.access-management.readonly_user_access_key_id)
#   description = "The access key ID for the read-only user"
# }

# output "readonly_secret_access_key" {
#   value       = nonsensitive(module.access-management.readonly_user_secret_access_key)
#   description = "The secret access key for the read-only user"
# }

# output "readonly_user_exp_access_key_id" {
#   value       = nonsensitive(module.access-management.readonly_user_exp_access_key_id)
#   description = "The access key ID for the read-only user exp"
# }

# output "readonly_user_exp_secret_access_key" {
#   value       = nonsensitive(module.access-management.readonly_user_exp_secret_access_key)
#   description = "The secret access key for the read-only user exp"
# }

# output "developer_access_key_id" {
#   value       = nonsensitive(module.access-management.developer_access_key_id)
#   description = "The access key ID for the developer user"
# }

# output "developer_secret_access_key" {
#   value       = nonsensitive(module.access-management.developer_secret_access_key)
#   description = "The secret access key for the developer user"
# }

# output "tester_access_key_id" {
#   value       = nonsensitive(module.access-management.tester_access_key_id)
#   description = "The access key ID for the tester user"
# }

# output "tester_secret_access_key" {
#   value       = nonsensitive(module.access-management.tester_secret_access_key)
#   description = "The secret access key for the tester user"
# }

# output "programmer_access_key_id" {
#   value       = nonsensitive(module.access-management.programmer_access_key_id)
#   description = "The access key ID for the programmer user"
# }

# output "programmer_secret_access_key" {
#   value       = nonsensitive(module.access-management.programmer_secret_access_key)
#   description = "The secret access key for the programmer user"
# }

# ArgoCD and Argo Workflows outputs

# output "argocd_release_name" {
#   description = "The name of the ArgoCD Helm release"
#   value       = module.helm-charts.argocd_release_name
# }

# output "argocd_status" {
#   description = "The status of the ArgoCD Helm release"
#   value       = module.helm-charts.argocd_status
# }

# output "argo_workflows_release_name" {
#   description = "The name of the Argo Workflows Helm release"
#   value       = module.helm-charts.argo_workflows_release_name
# }

# output "argo_workflows_status" {
#   description = "The status of the Argo Workflows Helm release"
#   value       = module.helm-charts.argo_workflows_status
# }
