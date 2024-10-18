variable "namespace" {
  description = "The Vault namespace where the OIDC role should be created"
  type        = string
}

variable "oidc_backend_path" {
  description = "The path of the OIDC backend"
  type        = string
}

variable "allowed_redirect_uris" {
  description = "Allowed redirect URIs for the OIDC role"
  type        = list(string)
}

