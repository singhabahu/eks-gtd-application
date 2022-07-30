resource "aws_iam_policy" "load_balancer_controller_policy" {
  name   = var.load_balancer_controller_policy_name
  policy = file("policies/aws-load-balancer-controller.json")
}
