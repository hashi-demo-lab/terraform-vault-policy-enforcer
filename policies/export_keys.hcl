path "dev-team/transit/export/encryption-key/*" {
capabilities = ["read"]
}

path "dev-team/transit/keys/*" {
capabilities = ["deny"]
}

path "dev-team/transit/*" {
capabilities = ["deny"]
}

path "sys/mounts" {
capabilities = ["deny"]
}