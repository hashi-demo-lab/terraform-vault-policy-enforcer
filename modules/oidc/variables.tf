variable "vault_oidc_client_id" {
  description = "OIDC client ID"
  type        = string
}

variable "vault_oidc_client_secret" {
  description = "OIDC client secret"
  type        = string
}

variable "namespace" {
  description = "Vault namespace for the OIDC auth backend"
  type        = string
}

variable "token_policy" {
  description = "The token policy to attach to the OIDC role"
  type        = string
}