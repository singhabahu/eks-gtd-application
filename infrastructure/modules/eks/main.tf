module "vpc_cni_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "5.2.0"

  role_name_prefix      = "VPC-CNI-IRSA"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = var.eks_cluster_name
  cluster_version = var.eks_cluster_version

  vpc_id     = data.terraform_remote_state.vpc.outputs.vpc_id
  subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  cluster_addons = {
    coredns = {
      addon_version     = var.eks_cluster_addons_versions["coredns"]
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      addon_version     = var.eks_cluster_addons_versions["kube-proxy"]
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      addon_version            = var.eks_cluster_addons_versions["vpc-cni"]
      resolve_conflicts        = "OVERWRITE"
      service_account_role_arn = module.vpc_cni_irsa.iam_role_arn
    }
  }

  cluster_encryption_config = [
    {
      provider_key_arn = aws_kms_key.eks_key.arn
      resources        = ["secrets"]
    }
  ]

  cluster_security_group_additional_rules = {
    ingress_bastion = {
      description              = "Allow HTTPS from bastion"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
      source_security_group_id = data.terraform_remote_state.bastion.outputs.bastion_security_group
    }
  }

  node_security_group_additional_rules = {
    ingress_bastion = {
      description                   = "Allow access from control plane to webhook port of AWS load balancer controller"
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 9443
      to_port                       = 9443
      source_cluster_security_group = true
    }

    ingress_metric_server = {
      description                   = "Cluster to node 4443 (Metrics Server)"
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 4443
      to_port                       = 4443
      source_cluster_security_group = true
    }

    egress_database_server = {
      description = "Allow access to database server"
      protocol    = "tcp"
      from_port   = 5432
      to_port     = 5432
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  eks_managed_node_group_defaults = {
    ami_type                   = var.eks_managed_node_group["ami_type"]
    disk_size                  = var.eks_managed_node_group["disk_size"]
    iam_role_attach_cni_policy = true
    disable_api_termination    = false
  }

  eks_managed_node_groups = {
    managed = {
      subnet_ids = data.terraform_remote_state.vpc.outputs.private_subnets

      min_size       = var.eks_managed_node_group["min_size"]
      max_size       = var.eks_managed_node_group["max_size"]
      desired_size   = var.eks_managed_node_group["desired_size"]
      instance_types = var.eks_managed_node_group["instance_types"]
      capacity_type  = var.eks_managed_node_group["capacity_type"]
    }
  }

  tags = {
    Environment = "dev"
  }
}

resource "aws_kms_key" "eks_key" {
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true
}
