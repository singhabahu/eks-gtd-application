# EKS-GTD-Application

## Introduction
Terraform modules to support deploying EKS cluster with GTD application.

## Requirements
- AWS access to deploy EKS and modules listed in the repository (EKS, IAM, S3, RDS, SecretsManager, ELB, ACM...)
- Terraform (v1.2.5)
- Terragrunt (v0.38.6)
- AWS CLI
- Make

## Design
### AWS
High level architecture consists of a VPC with three subnets along with the EKS cluster.

![image](https://user-images.githubusercontent.com/22044130/182176653-45ef0798-eb92-49d0-aac0-47fbc631d9e0.png)

### Terragrunt
Terragrunt is a thin wrapper for Terraform that provides extra tools for keeping your Terraform configurations DRY. This was used to achieve following features
- Modular design to make it easy to apply/modify and delete each component separately
- DRY code base for repetitive code blocks
- Use of built-in functions to reduce 3rd party scripts
```bash
# Example of DRY use of backend config
remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = local.bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    kms_key_id     = "alias/terraform-bucket-key"
    region         = local.region
    encrypt        = true
    dynamodb_table = "demo-eks-state-lock"
  }
}
```
### Git Workflow
This repository follows the Git Workflow practices.
```bash
# Example of branch naming for feature development
feature/provisioner-update-rds
feature/state-backend
# Example of branch naming for hotfixes
hotfix/add-metrics-server
hotfix/application-config
hotfix/hpa-deprecated-warning
# Example of branch naming for other topics
topic/documentation-improvements
topic/documents
``` 

## Setup
Following ENV vars are required to setup the infrastructure.

```bash
# Required variables
export AWS_SECRET_ACCESS_KEY={aws_secret_access_key}
export AWS_ACCESS_KEY_ID={aws_access_key_id}

# Defults - No need to set explicitly
export AWS_DEFAULT_REGION=ap-southeast-2
export S3_STATE_BUCKET=demo-eks-state
export EKS_CLUSTER_NAME=demo-eks-cluster
```
 
In order to deploy the solution following step can be executed.

```bash
make apply-all
```

If there's a problem with any particular module, that can be re-applied using the `make create-{module_name}`

```bash
# Example
make create-vpc
```

Destroy can be performed with the following command but make sure to delete the helm chart manually to remove the ALB

```bash
# From bastion host
export AWS_SECRET_ACCESS_KEY={aws_secret_access_key}
export AWS_ACCESS_KEY_ID={aws_access_key_id}

aws eks update-kubeconfig --region {region} --name {cluster_name}
helm uninstall demo -n servian
# From local machine
make destroy-all:
```

## CI/CD
CI is setup using GitHub [actions](https://github.com/singhabahu/eks-gtd-application/actions) to validate each terraform module dependencies and its formatting. CD is not included in the scope is this project.

## Demo
Once the application deployment is complete by the provisioner it will generate the URL for users to access
```bash
# Example of the provisioner output
null_resource.bastion_host (remote-exec): Note that it can take some time to provision the ALB (~3mins) so below URL might not be available right away
null_resource.bastion_host (remote-exec): Please visit to access the application: https://k8s-servian-demotech-a07a347a2c-445616228.ap-southeast-2.elb.amazonaws.com
null_resource.bastion_host: Creation complete after 57s [id=2239249671056644405]
Releasing state lock. This may take a few moments...

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

When acceced via the browser application will look like this

<img width="1680" alt="image" src="https://user-images.githubusercontent.com/22044130/182297952-0b74668f-f350-4282-850c-c2bd70470041.png">

Health endpoint will return the status of the application

![image](https://user-images.githubusercontent.com/22044130/182298233-4cb6ed4b-5af8-45f7-9d78-64be897e4521.png)

## Limitations and Improvements
### Limitations
- HTTPS was used with TLS self-signed certificate
![image](https://user-images.githubusercontent.com/22044130/182298100-92e6c37e-f2fc-4e65-9692-8dc328ecf89d.png)

### Improvements
- Introduce cluster-autoscaler to scale nodes based on resources utilization
- Introduce a CD tool like Flux for automated deployments
- Introduce secrets-store-csi-driver-provider-aws for more secure secret management
- Improve overall cluster monitoring and logging

