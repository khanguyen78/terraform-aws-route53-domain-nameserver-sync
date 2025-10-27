variable "domain_name" {
  description = "The registered domain name in Route 53 (e.g. example.com)"
  type        = string
}

variable "hosted_zone_id" {
  description = "Optional hosted zone ID (if not provided, the module looks up by domain name)"
  type        = string
  default     = null
}

