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

High level architecture consists of a VPC with three subnets along with the EKS cluster.

![image](https://user-images.githubusercontent.com/22044130/182176653-45ef0798-eb92-49d0-aac0-47fbc631d9e0.png)

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

If there's a problem with any perticular module, that can be re-applied using the `make create-{module_name}`

```bash
# Example
make create-vpc
```

Destroy can be performed with the following command but make sure to delete the helm chart manually to remove the ALB

```bash
# From bastion host
export AWS_SECRET_ACCESS_KEY={aws_secret_access_key}
export AWS_ACCESS_KEY_ID={aws_access_key_id}

aws eks update-kubeconfig --region {region} --name
{cluster_name}
helm uninstall demo -n servian
# From local machine
make destroy-all:
```

## CI/CD
CI is setup using GitHub actions to validate each terraform module dependencies and it's formatting. CD is not included in the scope is this project.

## Limitations and Improvements
### Limitations
- HTTPS was used with TLS self-singed certificate was used
### Improvements
- Introduce cluster-autoscaler to scale nodes based on resources utilization
- Introduce a CD tool like Flux for automated deployments
- Introduce secrets-store-csi-driver-provider-aws for more secure secret management
- Improve overall cluster monitoring and logging

