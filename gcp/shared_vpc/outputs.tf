output "example-network" {
  value = zipmap(
    [for value in google_compute_shared_vpc_service_project.example-projects : tostring(value.service_project)],
    [for value in google_compute_shared_vpc_service_project.example-projects : {
      "vpc-id"              = google_compute_network.example-vpcs[value.service_project].id,
      "subnet-public-id"    = google_compute_subnetwork.example-public-subnets[value.service_project].id,
      "external-ip-id"      = google_compute_address.example-external-ips[value.service_project].id,
      "external-ip-address" = google_compute_address.example-external-ips[value.service_project].address,
      "ip-id"               = google_compute_address.example-ips[value.service_project].id,
      "ip-address"          = google_compute_address.example-ips[value.service_project].address
    }]
  )
}
