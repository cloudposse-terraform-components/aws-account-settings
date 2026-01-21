variable "region" {
  type        = string
  description = "AWS Region"
}

variable "account_alias" {
  type        = string
  description = "The IAM account alias. If not set, uses the module ID"
  default     = null
}

variable "account_alias_enabled" {
  type        = bool
  description = "Whether to create the IAM account alias"
  default     = true
}

variable "s3_block_public_access_enabled" {
  type        = bool
  description = "Whether to enable S3 account-level public access block"
  default     = true
}

variable "s3_block_public_acls" {
  type        = bool
  description = "Whether to block public ACLs"
  default     = true
}

variable "s3_block_public_policy" {
  type        = bool
  description = "Whether to block public bucket policies"
  default     = true
}

variable "s3_ignore_public_acls" {
  type        = bool
  description = "Whether to ignore public ACLs"
  default     = true
}

variable "s3_restrict_public_buckets" {
  type        = bool
  description = "Whether to restrict public buckets"
  default     = true
}

variable "ebs_default_encryption_enabled" {
  type        = bool
  description = "Whether to enable EBS default encryption"
  default     = true
}

variable "ebs_default_kms_key_arn" {
  type        = string
  description = "The ARN of the KMS key for EBS default encryption. If not set, uses the AWS-managed key."
  default     = null
}

variable "billing_contact" {
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  description = "Billing alternate contact information"
  default     = null
}

variable "operations_contact" {
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  description = "Operations alternate contact information"
  default     = null
}

variable "security_contact" {
  type = object({
    name          = string
    title         = string
    email_address = string
    phone_number  = string
  })
  description = "Security alternate contact information"
  default     = null
}

variable "ssm_session_preferences_enabled" {
  type        = bool
  description = "Whether to configure SSM Session Manager preferences (idle timeout)"
  default     = false
}

variable "ssm_session_idle_timeout_minutes" {
  type        = number
  description = "The idle session timeout in minutes for SSM Session Manager. AWS default is 20 minutes."
  default     = 20

  validation {
    condition     = var.ssm_session_idle_timeout_minutes >= 1 && var.ssm_session_idle_timeout_minutes <= 60
    error_message = "ssm_session_idle_timeout_minutes must be between 1 and 60 minutes."
  }
}
