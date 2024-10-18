output "jwt_auth_backend_path" {
  value = vault_jwt_auth_backend.oidc.path
}

output "jwt_auth_backend_accessor" {
  value = vault_jwt_auth_backend.oidc.accessor
}