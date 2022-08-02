## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.23.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_database_security_group"></a> [database\_security\_group](#module\_database\_security\_group) | terraform-aws-modules/security-group/aws | n/a |
| <a name="module_db"></a> [db](#module\_db) | terraform-aws-modules/rds/aws | n/a |
| <a name="module_secretsmanager_database_password"></a> [secretsmanager\_database\_password](#module\_secretsmanager\_database\_password) | ../secretsmanager | n/a |
| <a name="module_secretsmanager_database_username"></a> [secretsmanager\_database\_username](#module\_secretsmanager\_database\_username) | ../secretsmanager | n/a |

## Resources

| Name | Type |
|------|------|
| [terraform_remote_state.eks](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |
| [terraform_remote_state.vpc](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket"></a> [bucket](#input\_bucket) | State bucket name | `string` | n/a | yes |
| <a name="input_eks_key"></a> [eks\_key](#input\_eks\_key) | Path to the EKS state file | `string` | n/a | yes |
| <a name="input_rds_configuration"></a> [rds\_configuration](#input\_rds\_configuration) | RDS configuration | `map(any)` | <pre>{<br>  "allocated_storage": "5",<br>  "db_name": "demo_db",<br>  "engine": "postgres",<br>  "engine_version": "13.4",<br>  "family": "postgres13",<br>  "identifier": "demo-postgres",<br>  "instance_class": "db.t3.small",<br>  "multi_az": true,<br>  "port": "5432",<br>  "username": "demo_user"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region | `string` | n/a | yes |
| <a name="input_vpc_key"></a> [vpc\_key](#input\_vpc\_key) | Path to the VPC state file | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | The database address |
| <a name="output_db_instance_name"></a> [db\_instance\_name](#output\_db\_instance\_name) | The database name |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | The database port |
| <a name="output_secretsmanager_database_password"></a> [secretsmanager\_database\_password](#output\_secretsmanager\_database\_password) | Secrets Manager ARN for the database password |
| <a name="output_secretsmanager_database_username"></a> [secretsmanager\_database\_username](#output\_secretsmanager\_database\_username) | Secrets Manager ARN for the database username |
