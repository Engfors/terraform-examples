# Composer

## Getting started

To initiate Terraform and correct workspace in your local folder, do the following:

```terraform
terraform init
```

*This will initiate Terraform and download any specified provider* </br></br>

```terraform
terraform workspace select test
```

or

```terraform
terraform workspace select prod
```

*this will select the environment you want to make changes to* </br></br>

## Terraform service account

### Download a Service account key

```sh
gcloud iam service-accounts keys create ./terraform.json   --iam-account  terraform@gcp-project.iam.gserviceaccount.com
```

### Using the service account key

Use an environment variable for credentials </br>

```sh
export GOOGLE_CREDENTIALS=$(cat terraform.json | jq -c)
```

## Terraform variables

The variables used by Terraform are set for each workspace by using its respective `*.tfvars` file. </br>

### Using `*.tfvars`

Option A: Create a symbolic link to the file by using like this </br>

```sh
ln -s test-env.tfvars terraform.tfvars
```

*You are now able to run `terraform plan/apply` as expected*
</br>
</br>

Option B: Reference directly to the file by using the flag `--var-file` like this </br>

```terraform
terraform plan --var-file test-env.tfvars
```

### Applying terraform configuration to environment

For test

```terraform
terraform apply --var-file test-env.tfvars
```
