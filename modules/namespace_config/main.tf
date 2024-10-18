terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.3.0"
    }
  }
}

# OIDC auth role in the provided namespace
resource "vault_jwt_auth_backend_role" "oidc_role_dev" {
  namespace      = var.namespace  # Use the namespace variable
  backend        = var.oidc_backend_path  # Reference the OIDC backend path from the oidc module
  role_name      = "demo"
  token_policies = ["dev"]

  allowed_redirect_uris = var.allowed_redirect_uris
  user_claim            = "email"
  claim_mappings = {
    "email" = "email"
    "name"  = "name"
  }
}
