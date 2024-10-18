variable "namespace" {
  description = "The Vault namespace where the OIDC role should be created"
  type        = string
}

variable "oidc_backend_path" {
  description = "The path of the OIDC backend"
  type        = string
}
