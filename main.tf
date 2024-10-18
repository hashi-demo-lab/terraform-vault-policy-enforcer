resource "vault_namespace" "dev_team_namespace" {
  path = var.namespace
}

module "oidc" {
  source = "./modules/oidc"

  vault_oidc_client_id     = var.vault_oidc_client_id
  vault_oidc_client_secret = var.vault_oidc_client_secret
  namespace                = vault_namespace.dev_team_namespace.path # Pass the created namespace
  token_policy             = "dev"
  allowed_redirect_uris    = var.allowed_redirect_uris
}

module "namespaces" {
  source = "./modules/namespace_config"

  oidc_backend_path = module.oidc.jwt_auth_backend_path
  namespace         = vault_namespace.dev_team_namespace.path # Pass the created namespace
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
  mount_accessor = module.oidc.jwt_auth_backend_accessor
  canonical_id   = vault_identity_entity.cloubrokeraz.id
  namespace      = vault_namespace.dev_team_namespace.path
}

resource "vault_auth_backend" "userpass" {
  type = "userpass"
}

resource "vault_generic_endpoint" "security_audit_user" {
  depends_on           = [vault_auth_backend.userpass]
  path                 = "auth/userpass/users/security_audit_user"
  ignore_absent_fields = true
  data_json            = <<EOT
  {
    "password": "password"
  }
  EOT
}

resource "vault_identity_entity" "security_audit_user_entity" {
  name     = "security_audit_user"
  policies = [vault_policy.export_keys.name]
  metadata = {
    organization = "Security Team"
    role         = "Audit"
  }
}

# Create an alias to associate the entity with the userpass auth method
resource "vault_identity_entity_alias" "security_audit_user_alias" {
  name           = "security_audit_user"                               # The username in userpass auth method
  mount_accessor = vault_auth_backend.userpass.accessor                # Refers to the userpass auth method
  canonical_id   = vault_identity_entity.security_audit_user_entity.id # The ID of the entity
}