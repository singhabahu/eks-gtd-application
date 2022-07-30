resource "aws_iam_policy" "load_balancer_controller_policy" {
  name   = var.load_balancer_controller_policy_name
  policy = file("policies/aws-load-balancer-controller.json")
}

resource "aws_iam_role" "load_balancer_controller_role" {
  name                 = var.load_balancer_controller_role_name
  assume_role_policy   = data.aws_iam_policy_document.load_balancer_role_trust_policy.json
  max_session_duration = var.max_session_duration
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.load_balancer_controller_role.name
  policy_arn = aws_iam_policy.load_balancer_controller_policy.arn
}
