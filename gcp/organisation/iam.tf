resource "google_organization_iam_policy" "organization" {
  org_id = var.org_id
  policy_data = jsonencode(
    {
      bindings = [
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/bigquery.dataViewer"
        },
        {
          members = [
            "group:gcp-billing-admins@${var.domain}",
          ]
          role = "roles/billing.admin"
        },
        {
          members = [
            "domain:${var.domain}",
            "group:gcp-billing-admins@${var.domain}",
          ]
          role = "roles/billing.creator"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
          ]
          role = "roles/billing.user"
        },
        {
          members = [
            "serviceAccount:service-org-${var.org_id}@security-center-api.iam.gserviceaccount.com",
          ]
          role = "roles/cloudfunctions.serviceAgent"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
          ]
          role = "roles/cloudsupport.admin"
        },
        {
          members = [
            "group:gcp-network-admins@${var.domain}",
          ]
          role = "roles/compute.networkAdmin"
        },
        {
          members = [
            "group:gcp-network-admins@${var.domain}",
          ]
          role = "roles/compute.securityAdmin"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/compute.viewer"
        },
        {
          members = [
            "group:gcp-network-admins@${var.domain}",
          ]
          role = "roles/compute.xpnAdmin"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/container.viewer"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
          ]
          role = "roles/iam.organizationRoleAdmin"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/iam.organizationRoleViewer"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/iam.securityReviewer"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/logging.configWriter"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/logging.privateLogViewer"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/orgpolicy.policyAdmin"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/orgpolicy.policyViewer"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
          ]
          role = "roles/resourcemanager.folderAdmin"
        },
        {
          members = [
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/resourcemanager.folderIamAdmin"
        },
        {
          members = [
            "group:gcp-devops@${var.domain}",
            "group:gcp-network-admins@${var.domain}",
          ]
          role = "roles/resourcemanager.folderViewer"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
            "user:emil@${var.domain}",
            "user:engfors.emil@gmail.com",
          ]
          role = "roles/resourcemanager.organizationAdmin"
        },
        {
          members = [
            "group:gcp-billing-admins@${var.domain}",
          ]
          role = "roles/resourcemanager.organizationViewer"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
          ]
          role = "roles/resourcemanager.projectCreator"
        },
        {
          members = [
            "group:gcp-organization-admins@${var.domain}",
            "group:gcp-security-admins@${var.domain}",
          ]
          role = "roles/securitycenter.admin"
        },
        {
          members = [
            "serviceAccount:service-org-${var.org_id}@security-center-api.iam.gserviceaccount.com",
          ]
          role = "roles/securitycenter.serviceAgent"
        },
        {
          members = [
            "serviceAccount:service-org-${var.org_id}@security-center-api.iam.gserviceaccount.com",
          ]
          role = "roles/serviceusage.serviceUsageAdmin"
        },
      ]
    }
  )
}
