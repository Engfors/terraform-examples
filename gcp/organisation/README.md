# Example Infrastructure Terraform

# Organisation
This  is used to create an organisations with folders and projects 

## Variables used

org_id 
* your organisation id 

billing_account 
* your billing account 

domain 
* your domain (Example.com) 

organisation 
* used to tag resources with org name (example-infra-host-vpc) 

root_folders
* creates projects for each list entry, list in format [ "example-infra", "unsorted" ]	

example-infra_projects 
* creates projects for each list entry, list in format [ "example-infra-terraform", "example-infra-operations", "example-infra-monitoring", "example-infra-host-vpc" ]	
