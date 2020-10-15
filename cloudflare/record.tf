// Create dns A records for example.com
module "example_com_ipv4" {
  source = "git@github.com:Engfors/terraform-cloudflare-dns-record.git"

  zone_id = var.cloudflare_zone_id
  name    = "example.com"
  value   = var.example_com_ipv4
  type    = "A"
  proxied = true
}

// Create dns AAAA records for example.com
module "example_com_ipv6" {
  source = "git@github.com:Engfors/terraform-cloudflare-dns-record.git"

  zone_id = var.cloudflare_zone_id
  value   = var.example_com_ipv6
  type    = "AAAA"
}

// Create dns CNAME record for ghs.googlehosted.com
module "cname" {
  source = "git@github.com:Engfors/terraform-cloudflare-dns-record.git"

  zone_id = var.cloudflare_zone_id
  name    = "cname"
  value   = var.cname
  type    = "CNAME"
}

// Create txt records for google site verification
module "txt" {
  source = "git@github.com:Engfors/terraform-cloudflare-dns-record.git"

  zone_id = var.cloudflare_zone_id
  value   = var.google_site_verification
  type    = "TXT"
}

variable "cloudflare_zone_id" {}
variable "cname" {}
variable "example_com_ipv4" {}
variable "example_com_ipv6" {}
variable "google_site_verification" {}
