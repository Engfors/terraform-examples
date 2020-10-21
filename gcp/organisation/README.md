# Organisation
This example is used to create an organisations according to the following diagram
![alt text](https://ssl.gstatic.com/pantheon/images/gettingstarted/checklist-resource-hierarchy2.png)

The *resource "google_project" "terraform"* should not be created by terraform and should instead be pre-created manually and later imported to the Terraform state.
<br> This project is used to create a service account + key for use with Terraform, add this SA to your admin groups.

## Variables used

org_id 
* your organisation id 

billing_account 
* your billing account 

domain 
* your domain (example.com) 

organisation 
* used to tag resources with org name (example-vpc-host-prod) 

shared_production_projects
* creates project for each list entry, list in format [ "vpc-host-prod", "vpc-monitoring-prod", "vpc-logging-prod" ]	

production_projects 
* creates project for each list entry, list in format [ "prod" ], this example will create a project named "example-prod" 

shared_nonproduction_projects 
* creates project for each list entry, list in format [ "vpc-host-prod", "vpc-monitoring-prod", "vpc-logging-prod" ]	

nonproduction_projects 
* creates project for each list entry, list in format [ "playground" ], this example will create a project named "example-playground" 

