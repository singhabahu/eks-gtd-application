resource "aws_iam_role" "role" {
  name                 = var.role_name
  assume_role_policy   = data.aws_iam_policy_document.bastion_sts_policy_document.json
  max_session_duration = var.max_session_duration
}

resource "aws_iam_policy" "policy" {
  name   = var.policy_name
  policy = data.aws_iam_policy_document.bastion_eks_policy_document.json
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = var.instance_profile_name
  role = aws_iam_role.role.name
}
