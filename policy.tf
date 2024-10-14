# Create aaron's policy in the root namespace
resource "vault_policy" "dev" {
  name      = "dev"
  policy    = file("policies/dev.hcl")
  namespace = vault_namespace.dev_team_namespace.path
}

resource "vault_egp_policy" "force_exportable" {
  name              = "strict-transit-key-policy"
  paths             = ["transit/keys/*"]
  enforcement_level = "hard-mandatory"

  # Read the Sentinel policy from the local file 'force-exportable.sentinel'
  policy = file("policies/strict-transit-key-policy.sentinel")

  namespace = vault_namespace.dev_team_namespace.path
}