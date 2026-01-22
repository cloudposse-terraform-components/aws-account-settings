---
tags:
  - component/account-settings
  - layer/accounts
  - provider/aws
  - privileged
---

# Component: `account-settings`

This component is responsible for provisioning account level settings: AWS Account Alias, EBS encryption, S3 block public access, alternate contacts, and SSM session preferences.
## Usage

**Stack Level**: Global

Here's an example snippet for how to use this component. It's suggested to apply this component to all accounts, so
create a file `stacks/catalog/account-settings.yaml` with the following content and then import that file in each
account's global stack (overriding any parameters as needed):

```yaml
components:
  terraform:
    account-settings:
      vars:
        enabled: true
        account_alias_enabled: true
        s3_block_public_access_enabled: true
        ebs_default_encryption_enabled: true
        billing_contact:
          name: "John Doe"
          title: "CFO" 
          email_address: "billing@example.com"
          phone_number: "+1-555-123-4567"
        operations_contact:
          name: "Jane Smith"
          title: "DevOps Lead"
          email_address: "ops@example.com"
          phone_number: "+1-555-234-5678"
        security_contact:
          name: "Bob Wilson"
          title: "CISO"
          email_address: "security@example.com"
          phone_number: "+1-555-345-6789"
        ssm_session_preferences_enabled: true
        ssm_session_idle_timeout_minutes: 30
```

<!-- prettier-ignore-start -->
<!-- prettier-ignore-end -->


<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.9.0, < 6.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.9.0, < 6.0.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [aws_account_alternate_contact.billing](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.operations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_account_alternate_contact.security](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/account_alternate_contact) | resource |
| [aws_ebs_default_kms_key.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_default_kms_key) | resource |
| [aws_ebs_encryption_by_default.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ebs_encryption_by_default) | resource |
| [aws_iam_account_alias.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_account_alias) | resource |
| [aws_s3_account_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_account_public_access_block) | resource |
| [aws_ssm_document.session_manager_prefs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_document) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_alias"></a> [account\_alias](#input\_account\_alias) | The IAM account alias. If not set, uses the module ID | `string` | `null` | no |
| <a name="input_account_alias_enabled"></a> [account\_alias\_enabled](#input\_account\_alias\_enabled) | Whether to create the IAM account alias | `bool` | `true` | no |
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional key-value pairs to add to each map in `tags_as_list_of_maps`. Not added to `tags` or `id`.<br/>This is for some rare cases where resources want additional configuration of tags<br/>and therefore take a list of maps with tag key, value, and additional configuration. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | ID element. Additional attributes (e.g. `workers` or `cluster`) to add to `id`,<br/>in the order they appear in the list. New attributes are appended to the<br/>end of the list. The elements of the list are joined by the `delimiter`<br/>and treated as a single ID element. | `list(string)` | `[]` | no |
| <a name="input_billing_contact"></a> [billing\_contact](#input\_billing\_contact) | Billing alternate contact information | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = string<br/>  })</pre> | `null` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br/>See description of individual variables for details.<br/>Leave string and numeric variables as `null` to use default value.<br/>Individual variable settings (non-null) override settings in context object,<br/>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br/>  "additional_tag_map": {},<br/>  "attributes": [],<br/>  "delimiter": null,<br/>  "descriptor_formats": {},<br/>  "enabled": true,<br/>  "environment": null,<br/>  "id_length_limit": null,<br/>  "label_key_case": null,<br/>  "label_order": [],<br/>  "label_value_case": null,<br/>  "labels_as_tags": [<br/>    "unset"<br/>  ],<br/>  "name": null,<br/>  "namespace": null,<br/>  "regex_replace_chars": null,<br/>  "stage": null,<br/>  "tags": {},<br/>  "tenant": null<br/>}</pre> | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between ID elements.<br/>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_descriptor_formats"></a> [descriptor\_formats](#input\_descriptor\_formats) | Describe additional descriptors to be output in the `descriptors` output map.<br/>Map of maps. Keys are names of descriptors. Values are maps of the form<br/>`{<br/>  format = string<br/>  labels = list(string)<br/>}`<br/>(Type is `any` so the map values can later be enhanced to provide additional options.)<br/>`format` is a Terraform format string to be passed to the `format()` function.<br/>`labels` is a list of labels, in order, to pass to `format()` function.<br/>Label values will be normalized before being passed to `format()` so they will be<br/>identical to how they appear in `id`.<br/>Default is `{}` (`descriptors` output will be empty). | `any` | `{}` | no |
| <a name="input_ebs_default_encryption_enabled"></a> [ebs\_default\_encryption\_enabled](#input\_ebs\_default\_encryption\_enabled) | Whether to enable EBS default encryption | `bool` | `true` | no |
| <a name="input_ebs_default_kms_key_arn"></a> [ebs\_default\_kms\_key\_arn](#input\_ebs\_default\_kms\_key\_arn) | The ARN of the KMS key for EBS default encryption. If not set, uses the AWS-managed key. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br/>Set to `0` for unlimited length.<br/>Set to `null` for keep the existing setting, which defaults to `0`.<br/>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_import_account_alias"></a> [import\_account\_alias](#input\_import\_account\_alias) | Set to the existing IAM account alias to import it into Terraform state. Set to null after successful import. | `string` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | Controls the letter case of the `tags` keys (label names) for tags generated by this module.<br/>Does not affect keys of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper`.<br/>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The order in which the labels (ID elements) appear in the `id`.<br/>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br/>You can omit any of the 6 labels ("tenant" is the 6th), but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | Controls the letter case of ID elements (labels) as included in `id`,<br/>set as tag values, and output by this module individually.<br/>Does not affect values of tags passed in via the `tags` input.<br/>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br/>Set this to `title` and set `delimiter` to `""` to yield Pascal Case IDs.<br/>Default value: `lower`. | `string` | `null` | no |
| <a name="input_labels_as_tags"></a> [labels\_as\_tags](#input\_labels\_as\_tags) | Set of labels (ID elements) to include as tags in the `tags` output.<br/>Default is to include all labels.<br/>Tags with empty values will not be included in the `tags` output.<br/>Set to `[]` to suppress all generated tags.<br/>**Notes:**<br/>  The value of the `name` tag, if included, will be the `id`, not the `name`.<br/>  Unlike other `null-label` inputs, the initial setting of `labels_as_tags` cannot be<br/>  changed in later chained modules. Attempts to change it will be silently ignored. | `set(string)` | <pre>[<br/>  "default"<br/>]</pre> | no |
| <a name="input_name"></a> [name](#input\_name) | ID element. Usually the component or solution name, e.g. 'app' or 'jenkins'.<br/>This is the only ID element not also included as a `tag`.<br/>The "name" tag is set to the full `id` string. There is no tag with the value of the `name` input. | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | ID element. Usually an abbreviation of your organization name, e.g. 'eg' or 'cp', to help ensure generated IDs are globally unique | `string` | `null` | no |
| <a name="input_operations_contact"></a> [operations\_contact](#input\_operations\_contact) | Operations alternate contact information | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = string<br/>  })</pre> | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Terraform regular expression (regex) string.<br/>Characters matching the regex will be removed from the ID elements.<br/>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | n/a | yes |
| <a name="input_s3_block_public_access_enabled"></a> [s3\_block\_public\_access\_enabled](#input\_s3\_block\_public\_access\_enabled) | Whether to enable S3 account-level public access block | `bool` | `true` | no |
| <a name="input_s3_block_public_acls"></a> [s3\_block\_public\_acls](#input\_s3\_block\_public\_acls) | Whether to block public ACLs | `bool` | `true` | no |
| <a name="input_s3_block_public_policy"></a> [s3\_block\_public\_policy](#input\_s3\_block\_public\_policy) | Whether to block public bucket policies | `bool` | `true` | no |
| <a name="input_s3_ignore_public_acls"></a> [s3\_ignore\_public\_acls](#input\_s3\_ignore\_public\_acls) | Whether to ignore public ACLs | `bool` | `true` | no |
| <a name="input_s3_restrict_public_buckets"></a> [s3\_restrict\_public\_buckets](#input\_s3\_restrict\_public\_buckets) | Whether to restrict public buckets | `bool` | `true` | no |
| <a name="input_security_contact"></a> [security\_contact](#input\_security\_contact) | Security alternate contact information | <pre>object({<br/>    name          = string<br/>    title         = string<br/>    email_address = string<br/>    phone_number  = string<br/>  })</pre> | `null` | no |
| <a name="input_ssm_session_idle_timeout_minutes"></a> [ssm\_session\_idle\_timeout\_minutes](#input\_ssm\_session\_idle\_timeout\_minutes) | The idle session timeout in minutes for SSM Session Manager. AWS default is 20 minutes. | `number` | `20` | no |
| <a name="input_ssm_session_preferences_enabled"></a> [ssm\_session\_preferences\_enabled](#input\_ssm\_session\_preferences\_enabled) | Whether to configure SSM Session Manager preferences (idle timeout) | `bool` | `false` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `{'BusinessUnit': 'XYZ'}`).<br/>Neither the tag keys nor the tag values will be modified by this module. | `map(string)` | `{}` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | ID element \_(Rarely used, not included by default)\_. A customer identifier, indicating who this instance of a resource is for | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_account_alias"></a> [account\_alias](#output\_account\_alias) | The IAM account alias |
| <a name="output_billing_contact_configured"></a> [billing\_contact\_configured](#output\_billing\_contact\_configured) | Whether billing contact was configured |
| <a name="output_ebs_encryption_configured"></a> [ebs\_encryption\_configured](#output\_ebs\_encryption\_configured) | Whether EBS default encryption was configured |
| <a name="output_operations_contact_configured"></a> [operations\_contact\_configured](#output\_operations\_contact\_configured) | Whether operations contact was configured |
| <a name="output_s3_public_access_block_configured"></a> [s3\_public\_access\_block\_configured](#output\_s3\_public\_access\_block\_configured) | Whether S3 public access block was configured |
| <a name="output_security_contact_configured"></a> [security\_contact\_configured](#output\_security\_contact\_configured) | Whether security contact was configured |
| <a name="output_ssm_session_idle_timeout_minutes"></a> [ssm\_session\_idle\_timeout\_minutes](#output\_ssm\_session\_idle\_timeout\_minutes) | The configured SSM session idle timeout in minutes |
| <a name="output_ssm_session_preferences_configured"></a> [ssm\_session\_preferences\_configured](#output\_ssm\_session\_preferences\_configured) | Whether SSM Session Manager preferences were configured |
<!-- markdownlint-restore -->



## References


- [cloudposse-terraform-components](https://github.com/orgs/cloudposse-terraform-components/repositories) - Cloud Posse's upstream component




[<img src="https://cloudposse.com/logo-300x69.svg" height="32" align="right"/>](https://cpco.io/homepage?utm_source=github&utm_medium=readme&utm_campaign=cloudposse-terraform-components/aws-account-settings&utm_content=)

