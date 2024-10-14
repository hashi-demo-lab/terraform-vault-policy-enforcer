resource "vault_namespace" "dev_team_namespace" {
  path = "dev-team"
}

# Aaron's identity entity within the dev namespace
resource "vault_identity_entity" "cloubrokeraz" {
  name     = "cloubrokeraz"
  policies = ["dev"]
  metadata = {
    user = "cloubrokeraz"
    team = "blue"
  }
  namespace = vault_namespace.dev_team_namespace.path
}

# Identity alias for OIDC login
resource "vault_identity_entity_alias" "aaron_oidc_alias" {
  name           = var.oidc_username
  mount_accessor = vault_jwt_auth_backend.oidc.accessor
  canonical_id   = vault_identity_entity.cloubrokeraz.id
  namespace      = vault_namespace.dev_team_namespace.path
}

# OIDC auth method in the root namespace
resource "vault_jwt_auth_backend" "oidc" {
  path               = "oidc"
  type               = "oidc"
  oidc_discovery_url = "https://gitlab.com"
  oidc_client_id     = var.vault_oidc_client_id
  oidc_client_secret = var.vault_oidc_client_secret
  default_role       = "demo"
  namespace          = vault_namespace.dev_team_namespace.path # Mount in dev namespace
}

# Configure the OIDC role for the dev namespace
resource "vault_jwt_auth_backend_role" "demo" {
  namespace      = vault_namespace.dev_team_namespace.path # Mount in dev namespace
  backend        = vault_jwt_auth_backend.oidc.path
  role_name      = "demo"
  token_policies = [vault_policy.dev.name]

  allowed_redirect_uris = var.allowed_redirect_uris
  user_claim            = "email"
  claim_mappings = {
    "email" = "email"
    "name"  = "name"
  }
}