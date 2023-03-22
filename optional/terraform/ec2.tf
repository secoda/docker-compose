################################################################################
# IAM
################################################################################

resource "aws_iam_instance_profile" "profile" {
  name = "secoda-instance-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role" "role" {
  name               = "secoda-instance-role"
  assume_role_policy = data.aws_iam_policy_document.role_policy.json
}

data "aws_iam_policy_document" "role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "policy" {
  name   = "secoda-role-instance-policy"
  role   = aws_iam_role.role.id
  policy = data.aws_iam_policy_document.instance_policy.json
}

data "aws_iam_policy_document" "instance_policy" {
  statement {
    effect    = "Allow"
    actions   = ["s3:*"]
    resources = [aws_s3_bucket.private.arn, "${aws_s3_bucket.private.arn}/*"]
  }
}

