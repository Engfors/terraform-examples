## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| google | ~> 3.51 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.51 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| required_apis | ./modules/enable_api |  |

## Resources

| Name |
|------|
| [google_compute_network](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_network) |
| [google_compute_router](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router) |
| [google_compute_router_nat](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_router_nat) |
| [google_compute_subnetwork](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_subnetwork) |
| [google_container_cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) |
| [google_container_node_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) |
| [google_project_iam_member](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) |
| [google_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) |
| [google_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) |
| [google_sql_database](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database) |
| [google_sql_database_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/sql_database_instance) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudsql\_tier | n/a | `any` | n/a | yes |
| cluster\_master\_ipv4\_cidr\_block | n/a | `list(string)` | n/a | yes |
| gcp\_project | n/a | `any` | n/a | yes |
| gcp\_region | n/a | `any` | n/a | yes |
| gcp\_zone | n/a | `any` | n/a | yes |
| gke\_machine\_type | n/a | `any` | n/a | yes |
| gke\_node\_count | n/a | `any` | n/a | yes |
| ip\_configuration | The ip\_configuration settings subblock | <pre>object({<br>    authorized_networks = list(map(string))<br>    ipv4_enabled        = bool<br>    private_network     = string<br>    require_ssl         = bool<br>  })</pre> | <pre>{<br>  "authorized_networks": [],<br>  "ipv4_enabled": true,<br>  "private_network": null,<br>  "require_ssl": null<br>}</pre> | no |
| primary\_ranges | n/a | `list(string)` | n/a | yes |
| secondary\_ranges | n/a | `list(string)` | n/a | yes |
| sql\_databases | n/a | `set(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gcp\_project | n/a |
| gcp\_region | n/a |
| google\_container\_cluster | n/a |
| google\_sql\_database\_instance | n/a |
| sqlproxy\_key | n/a |
