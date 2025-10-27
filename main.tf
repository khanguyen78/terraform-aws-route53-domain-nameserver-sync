############################################################
# Sync AWS Registered Domain with Hosted Zone Name Servers
############################################################

# Option 1: Use Hosted Zone ID directly
data "aws_route53_zone" "zone" {
  count        = var.hosted_zone_id != null ? 1 : 0
  zone_id      = var.hosted_zone_id
  private_zone = false
}

# Option 2: Or lookup hosted zone by domain name
data "aws_route53_zone" "by_name" {
  count        = var.hosted_zone_id == null ? 1 : 0
  name         = "${var.domain_name}."
  private_zone = false
}

locals {
  name_servers = coalesce(
    try(data.aws_route53_zone.zone[0].name_servers, null),
    try(data.aws_route53_zone.by_name[0].name_servers, null)
  )
}

# Always use us-east-1 for Route53Domains API
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_route53domains_registered_domain" "domain" {
  provider    = aws.us_east_1
  domain_name = var.domain_name

  dynamic "name_server" {
    for_each = toset(local.name_servers)
    content {
      name = name_server.value
    }
  }
}

