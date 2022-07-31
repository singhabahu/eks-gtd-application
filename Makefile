assert_aws_access_key_id:
ifndef AWS_ACCESS_KEY_ID
	@echo "AWS_ACCESS_KEY_ID must be set to before running"
endif

assert_aws_secret_access_key:
ifndef AWS_SECRET_ACCESS_KEY
	@echo "AWS_SECRET_ACCESS_KEY must be set to before running"
endif

assert_aws_config: assert_aws_access_key_id assert_aws_secret_access_key

init: assert_aws_config
	@echo "Initializing the S3 state bucket, note that state is in the .terragrunt-cache"
	cd dev/ap-southeast-2/state-backend/ && terragrunt init
	cd dev/ap-southeast-2/state-backend/ && terragrunt apply -auto-approve

create-vpc: assert_aws_config
	@echo "Apply VPC module"
	cd dev/ap-southeast-2/vpc/ && terragrunt init 
	cd dev/ap-southeast-2/vpc/ && terragrunt apply -auto-approve

create-bastion: assert_aws_config
	@echo "Apply Bastion module"
	cd dev/ap-southeast-2/bastion/ && terragrunt init
	cd dev/ap-southeast-2/bastion/ && terragrunt apply -auto-approve

create-eks: assert_aws_config
	@echo "Apply EKS module"
	cd dev/ap-southeast-2/eks/ && terragrunt init
	cd dev/ap-southeast-2/eks/ && terragrunt apply -auto-approve

create-acm: assert_aws_config
	@echo "Apply ACM module"
	cd dev/ap-southeast-2/acm/ && terragrunt init 
	cd dev/ap-southeast-2/acm/ && terragrunt apply -auto-approve

create-rds: assert_aws_config
	@echo "Apply RDS module"
	cd dev/ap-southeast-2/rds/ && terragrunt init 
	cd dev/ap-southeast-2/rds/ && terragrunt apply -auto-approve

create-provisioner: assert_aws_config
	@echo "Apply Provisioner module"
	cd dev/ap-southeast-2/provisioner/ && terragrunt init
	cd dev/ap-southeast-2/provisioner/ && terragrunt apply -auto-approve

decommission: assert_aws_config
	@echo "Decommissioning the S3 state bucket, note that state is in the .terragrunt-cache"
	cd dev/ap-southeast-2/state-backend/ && terragrunt init
	cd dev/ap-southeast-2/state-backend/ && terragrunt destroy -auto-approve

destroy-vpc: assert_aws_config
	@echo "Destroy VPC module"
	cd dev/ap-southeast-2/vpc/ && terragrunt init 
	cd dev/ap-southeast-2/vpc/ && terragrunt destroy -auto-approve

destroy-bastion: assert_aws_config
	@echo "Destroy Bastion module"
	cd dev/ap-southeast-2/bastion/ && terragrunt init
	cd dev/ap-southeast-2/bastion/ && terragrunt destroy -auto-approve

destroy-eks: assert_aws_config
	@echo "Destroy EKS module"
	cd dev/ap-southeast-2/eks/ && terragrunt init
	cd dev/ap-southeast-2/eks/ && terragrunt destroy -auto-approve

destroy-acm: assert_aws_config
	@echo "Destroy ACM module"
	cd dev/ap-southeast-2/acm/ && terragrunt init 
	cd dev/ap-southeast-2/acm/ && terragrunt destroy -auto-approve

destroy-rds: assert_aws_config
	@echo "Destroy RDS module"
	cd dev/ap-southeast-2/rds/ && terragrunt init 
	cd dev/ap-southeast-2/rds/ && terragrunt destroy -auto-approve

destroy-provisioner: assert_aws_config
	@echo "Destroy Provisioner module"
	cd dev/ap-southeast-2/provisioner/ && terragrunt init
	cd dev/ap-southeast-2/provisioner/ && terragrunt destroy -auto-approve

apply-all: init create-vpc create-bastion create-eks create-acm create-rds create-provisioner

destroy-all: destroy-provisioner destroy-rds destroy-acm destroy-eks destroy-bastion destroy-vpc decommission