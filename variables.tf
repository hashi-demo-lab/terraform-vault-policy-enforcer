variable "vault_address" {
  type        = string
  description = "Vault Address"
}

variable "vault_oidc_client_id" {
  description = "The OIDC client ID."
  type        = string
}

variable "vault_oidc_client_secret" {
  description = "The OIDC client secret."
  type        = string
  sensitive   = true
}

variable "oidc_username" {
  description = "The username for OIDC authentication."
  type        = string
}

variable "allowed_redirect_uris" {
  type        = list(string)
  description = "List of allowed redirect URIs for OIDC"
}