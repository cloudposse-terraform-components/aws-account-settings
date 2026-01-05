# Migration Guide: `account-settings` to `aws-account-settings`

This document outlines the migration from the old `account-settings` component to the new `aws-account-settings` component.

## Overview

The old `account-settings` component used the `cloudposse/iam-account-settings/aws` module and included budgets and service quotas management. The new `aws-account-settings` component is simplified and focused on core account settings.

### What Changed

| Feature | Old Component | New Component |
|---------|---------------|---------------|
| IAM Account Alias | Via module | Direct resource |
| IAM Password Policy | Via module | **Removed** (use AWS defaults or separate component) |
| EBS Default Encryption | Direct resource | Direct resource |
| S3 Block Public Access | Not included | **Added** |
| Alternate Contacts | Not included | **Added** |
| SSM Session Preferences | Not included | **Added** |
| Budgets | Included | **Removed** (use separate `aws-budgets` component) |
| Service Quotas | Included | **Removed** (use separate `aws-service-quotas` component) |
| Import Support | Not available | **Added** via OpenTofu 1.7+ |

### Why Migrate?

1. **Focused scope**: Each component does one thing well
2. **Import support**: Easily import existing resources
3. **S3 security**: Account-level S3 public access block
4. **Alternate contacts**: AWS alternate contacts for billing, ops, security
5. **Simpler provider**: No dependency on `account-map/modules/iam-roles`

---

## Migration Steps

### Phase 1: Prepare New Configuration

#### 1.1 Create Catalog Defaults

```yaml
# stacks/catalog/aws-account-settings/defaults.yaml
components:
  terraform:
    aws-account-settings/defaults:
      metadata:
        component: aws-account-settings
        type: abstract
      vars:
        enabled: true
        account_alias_enabled: true
        s3_block_public_access_enabled: true
        ebs_default_encryption_enabled: true
```

#### 1.2 Update Account Stacks

For each account's global stack:

```yaml
# stacks/orgs/<namespace>/<tenant>/<stage>/global-region.yaml
import:
  - catalog/aws-account-settings/defaults

components:
  terraform:
    aws-account-settings:
      metadata:
        inherits:
          - aws-account-settings/defaults
      vars:
        # Import the existing account alias
        import_account_alias: "<namespace>-<tenant>-<environment>-<stage>"
```

### Phase 2: Handle Removed Features

#### Budgets

If you were using budgets, migrate to a separate `aws-budgets` component:

```yaml
# Old configuration (in account-settings)
account-settings:
  vars:
    budgets_enabled: true
    budgets:
      - name: monthly-budget
        budget_type: COST
        limit_amount: "1000"
        limit_unit: USD
        time_unit: MONTHLY

# New configuration (separate component)
aws-budgets:
  vars:
    enabled: true
    budgets:
      - name: monthly-budget
        budget_type: COST
        limit_amount: "1000"
        limit_unit: USD
        time_unit: MONTHLY
```

#### Service Quotas

If you were using service quotas, migrate to a separate `aws-service-quotas` component:

```yaml
# Old configuration (in account-settings)
account-settings:
  vars:
    service_quotas_enabled: true
    service_quotas:
      - quota_name: Subnets per VPC
        service_code: vpc
        value: 250

# New configuration (separate component)
aws-service-quotas:
  vars:
    enabled: true
    service_quotas:
      - quota_name: Subnets per VPC
        service_code: vpc
        value: 250
```

#### IAM Password Policy

The IAM password policy is no longer managed by this component. Options:

1. **Use AWS defaults** - AWS has secure defaults for IAM password policy
2. **Create a separate component** - If you need custom password policy settings

### Phase 3: Deploy New Component

Deploy to each account:

```bash
# For each account stack
atmos terraform apply aws-account-settings -s <namespace>-gbl-<stage>
```

The import block will automatically import the existing account alias.

### Phase 4: Remove Old Component State

After successful migration, remove the old component's state:

```bash
# List resources in old state
atmos terraform state list account-settings -s <namespace>-gbl-<stage>

# Remove resources from state (DO NOT destroy!)
atmos terraform state rm account-settings -s <namespace>-gbl-<stage> \
  'aws_ebs_encryption_by_default.default[0]'

atmos terraform state rm account-settings -s <namespace>-gbl-<stage> \
  'module.iam_account_settings.aws_iam_account_alias.default[0]'

# Remove any other resources shown in state list
```

### Phase 5: Remove Old Component from Stack

After state is cleared:

```yaml
import:
  # Remove this line:
  # - catalog/account-settings
```

---

## Configuration Mapping

### Variables

| Old Variable | New Variable | Notes |
|--------------|--------------|-------|
| `minimum_password_length` | N/A | Removed - use separate component |
| `maximum_password_age` | N/A | Removed - use separate component |
| `budgets_enabled` | N/A | Removed - use `aws-budgets` component |
| `budgets` | N/A | Removed - use `aws-budgets` component |
| `service_quotas_enabled` | N/A | Removed - use `aws-service-quotas` component |
| `service_quotas` | N/A | Removed - use `aws-service-quotas` component |
| N/A | `account_alias_enabled` | New - enable/disable account alias |
| N/A | `account_alias` | New - custom alias (defaults to module.this.id) |
| N/A | `s3_block_public_access_enabled` | New - S3 public access block |
| N/A | `ebs_default_kms_key_arn` | New - custom KMS key for EBS |
| N/A | `billing_contact` | New - billing alternate contact |
| N/A | `operations_contact` | New - operations alternate contact |
| N/A | `security_contact` | New - security alternate contact |
| N/A | `ssm_session_preferences_enabled` | New - SSM session preferences |
| N/A | `import_account_alias` | New - import existing alias |

### Outputs

| Old Output | New Output | Notes |
|------------|------------|-------|
| `account_alias` | `account_alias` | Same |
| N/A | `s3_public_access_block_configured` | New |
| N/A | `ebs_encryption_configured` | New |
| N/A | `billing_contact_configured` | New |
| N/A | `operations_contact_configured` | New |
| N/A | `security_contact_configured` | New |
| N/A | `ssm_session_preferences_configured` | New |

---

## Troubleshooting

### Account Alias Already Exists

If you see:
```
Error: creating account alias: EntityAlreadyExists
```

Use the `import_account_alias` variable to import the existing alias:

```yaml
vars:
  import_account_alias: "your-existing-alias"
```

### S3 Public Access Block Breaks Website

If enabling S3 block public access breaks your S3 websites, either:

1. **Disable for this account**:
   ```yaml
   vars:
     s3_block_public_access_enabled: false
   ```

2. **Migrate to CloudFront OAC** (recommended):
   ```yaml
   spa-s3-cloudfront:
     vars:
       origin_access_control_enabled: true
       cloudfront_origin_access_identity_enabled: false
   ```

---

## References

- [OpenTofu Import Blocks](https://opentofu.org/docs/language/import/)
- [Atmos Documentation](https://atmos.tools/)
- [AWS S3 Block Public Access](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)
