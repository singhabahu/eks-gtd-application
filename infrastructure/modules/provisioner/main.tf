resource "local_sensitive_file" "credentials" {
  content  = <<-EOT
  export AWS_ACCESS_KEY_ID=${var.aws_access_key_id}
  export AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}
  export AWS_DEFAULT_REGION=${var.aws_default_region}
  EOT
  filename = "credentials"
}

resource "null_resource" "bastion_host" {
  connection {
    type        = "ssh"
    user        = "ec2-user"
    port        = 22
    private_key = data.aws_secretsmanager_secret_version.private_key_version.secret_string
    host        = data.aws_instance.bastion_instance.public_ip
    timeout     = "15s"
  }

  provisioner "file" {
    source      = "credentials"
    destination = "credentials"
  }

  provisioner "file" {
    content = templatefile("bootstrap/main.sh.tpl", {
      eks_region                        = var.aws_default_region
      eks_cluster_name                  = var.eks_cluster_name,
      load_balancer_controller_role_arn = data.terraform_remote_state.eks.outputs.load_balancer_controller_role
    })
    destination = "build.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sh build.sh"
    ]
  }
}
