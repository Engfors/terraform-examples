## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| google | ~> 3.51 |
| kubernetes | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.51 |
| kubernetes | ~> 2.0 |
| terraform | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [google_client_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) |
| [google_compute_global_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) |
| [google_container_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) |
| [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) |
| [google_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) |
| [kubernetes_deployment](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment) |
| [kubernetes_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress) |
| [kubernetes_namespace](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) |
| [kubernetes_secret](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret) |
| [kubernetes_service](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service) |
| [terraform_remote_state](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| core\_workspace | n/a | `any` | n/a | yes |
| gke\_namespaces | n/a | `set(string)` | `[]` | no |
| http\_ingress | List of deployment(s) using http ingress (no domain, no cert) | `set(string)` | `[]` | no |
| https\_ingress | List of deployment(s) using https ingress (domain + cert) | `map(any)` | `{}` | no |

## Outputs

No output.
