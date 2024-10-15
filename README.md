# Sentinel Policy for Vault Transit Key Enforcement

This repository contains a Sentinel policy designed to enforce specific security rules around the creation and management of Transit encryption keys within HashiCorp Vault. This policy is applied at the Enterprise Governance Policy (EGP) level and aims to showcase how Sentinel can be used to enforce fine-grained controls on key creation and updates.

## Overview

The purpose of this policy is to enforce two important security attributes for all Transit keys created or updated within Vault:

- **Exportable Keys**: Keys must always be created or updated with the `exportable` attribute set to `true`.
- **Deletion-Protected Keys**: Keys must always be created or updated with the `deletion_allowed` attribute set to `false`.

The policy ensures that these security attributes are enforced for all key management operations in the Vault environment. It is designed to demonstrate how Sentinel policies can add a layer of governance over Vault secrets management, allowing fine-grained control of operational parameters.

## Key Features

### Enforced Rules

- **Exportable Enforcement**: The policy ensures that the `exportable` attribute is **always true**. If not explicitly set during key creation or updates, the operation will be denied.
- **Deletion-Protected Enforcement**: The `deletion_allowed` attribute must always be **false**. Any attempt to set this to `true` will result in the operation being denied.

### Operation-Specific Handling

- **Key Rotation**: ### Key Rotation
The policy allows key rotation operations (`transit/keys/<key>/rotate`) to bypass the `exportable` and `deletion_allowed` checks, as these are considered update operations. Since key rotation is a specific update operation, it requires handling similar to other update operations but is allowed to proceed without requiring `exportable` to be set to true or `deletion_allowed` to be checked.
- **Read and List Operations**: Read and list operations are not subject to these policy checks, ensuring that users can view and list keys without hitting enforcement errors.

## How It Works

The Sentinel policy uses two main validation functions:

1. **Exportable Validation**: Ensures that when creating or updating keys, the `exportable` field is present and set to `true`. If this field is not provided or is set to `false`, the operation will be denied.

2. **Deletion-Allowed Validation**: Ensures that when creating or updating keys, the `deletion_allowed` field is present and set to `false`. If this field is not provided or is set to `true`, the operation will be denied.

### Skip Conditions

For certain operations (like reading, listing, or rotating keys), the policy allows the request to bypass the `exportable` and `deletion_allowed` checks. This is necessary because these operations do not alter the configuration of the key.

### Sentinel Policy Logic

```hcl
validate_exportable = func() {
  if request.operation == "read" or request.operation == "list" or request.path contains "/rotate" {
    return true
  }

  if "exportable" in keys(request.data) {
    if request.data.exportable != "true" {
      return false
    }
    return true
  } else {
    return false
  }
}

validate_deletion_allowed = func() {
  if request.operation == "read" or request.operation == "list" or request.path contains "/rotate" {
    return true
  }

  if "deletion_allowed" in keys(request.data) {
    if request.data.deletion_allowed != "false" {
      return false
    }
    return true
  } else {
    return false
  }
}

exportable_validated = validate_exportable()
deletion_allowed_validated = validate_deletion_allowed()

main = rule {
  exportable_validated and deletion_allowed_validated
}


---

This markdown file is structured to explain the purpose, functionality, and steps for testing the Sentinel policy in your lab environment, while demonstrating Vault governance.
