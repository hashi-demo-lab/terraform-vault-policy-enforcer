# Allow enabling only the Transit and KV secrets engines in the dev_team namespace
path "sys/mounts/transit" {
  capabilities = ["create", "update", "list"]
}

path "sys/mounts/kv" {
  capabilities = ["create", "update", "list"]
}

# Allow cloudbrokeraz to list the secrets engines (Transit and KV)
path "sys/mounts" {
  capabilities = ["read"]
}

# Allow cloudbrokeraz to manage any secrets in the KV engine
path "kv/data/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Allow cloudbrokeraz to list secrets under any KV path
path "kv/metadata/*" {
  capabilities = ["list"]
}

# Allow cloudbrokeraz to create and manage Transit keys
path "transit/keys/*" {
  capabilities = ["create", "read", "update", "list"]
}

# Allow cloudbrokeraz to perform encryption/decryption operations with his keys
path "transit/encrypt/*" {
  capabilities = ["update"]
}

path "transit/decrypt/*" {
  capabilities = ["update"]
}
