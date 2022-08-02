## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | 18.26.6 |
| <a name="module_vpc_cni_irsa"></a> [vpc\_cni\_irsa](#module\_vpc\_cni\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | 5.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_policy.load_balancer_controller_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.load_balancer_controller_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_key.eks_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.load_balancer_role_trust_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [terraform_remote_state.bastion](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bastion_key"></a> [bastion\_key](#input\_bastion\_key) | Path to the bastion state file | `string` | n/a | yes |
| <a name="input_bucket"></a> [bucket](#input\_bucket) | State bucket name | `string` | n/a | yes |
| <a name="input_eks_cluster_addons_versions"></a> [eks\_cluster\_addons\_versions](#input\_eks\_cluster\_addons\_versions) | The EKS cluster addon versions | `map(string)` | <pre>{<br>  "coredns": "v1.8.7-eksbuild.1",<br>  "kube-proxy": "v1.22.11-eksbuild.2",<br>  "vpc-cni": "v1.11.2-eksbuild.1"<br>}</pre> | no |
| <a name="input_eks_cluster_name"></a> [eks\_cluster\_name](#input\_eks\_cluster\_name) | The EKS cluster name | `string` | `"demo-eks-cluster"` | no |
| <a name="input_eks_cluster_version"></a> [eks\_cluster\_version](#input\_eks\_cluster\_version) | The EKS cluster K8 version | `string` | `"1.22"` | no |
| <a name="input_eks_managed_node_group"></a> [eks\_managed\_node\_group](#input\_eks\_managed\_node\_group) | The EKS cluster managed node group configs | <pre>object({<br>    ami_type       = string<br>    disk_size      = number<br>    min_size       = number<br>    max_size       = number<br>    desired_size   = number<br>    instance_types = list(string)<br>    capacity_type  = string<br>  })</pre> | <pre>{<br>  "ami_type": "AL2_x86_64",<br>  "capacity_type": "ON_DEMAND",<br>  "desired_size": 1,<br>  "disk_size": 10,<br>  "instance_types": [<br>    "t3.medium"<br>  ],<br>  "max_size": 3,<br>  "min_size": 1<br>}</pre> | no |
| <a name="input_load_balancer_controller_policy_name"></a> [load\_balancer\_controller\_policy\_name](#input\_load\_balancer\_controller\_policy\_name) | The load balancer controller policy name | `string` | `"AWSLoadBalancerControllerIAMPolicy"` | no |
| <a name="input_load_balancer_controller_role_name"></a> [load\_balancer\_controller\_role\_name](#input\_load\_balancer\_controller\_role\_name) | The load balancer controller role name | `string` | `"AWSLoadBalancerControllerRole"` | no |
| <a name="input_max_session_duration"></a> [max\_session\_duration](#input\_max\_session\_duration) | The maximum session duration (in seconds) that set for the specified role | `number` | `3600` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_vpc_key"></a> [vpc\_key](#input\_vpc\_key) | Path to the VPC state file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The Amazon Resource Name (ARN) of the cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready |
| <a name="output_cluster_node_security_group_id"></a> [cluster\_node\_security\_group\_id](#output\_cluster\_node\_security\_group\_id) | ID of the node shared security group |
| <a name="output_cluster_primary_security_group_id"></a> [cluster\_primary\_security\_group\_id](#output\_cluster\_primary\_security\_group\_id) | Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | The Kubernetes version for the cluster |
| <a name="output_load_balancer_controller_policy"></a> [load\_balancer\_controller\_policy](#output\_load\_balancer\_controller\_policy) | IAM policy ARN of the load balancer controller policy |
| <a name="output_load_balancer_controller_role"></a> [load\_balancer\_controller\_role](#output\_load\_balancer\_controller\_role) | IAM policy ARN of the load balancer controller role |
