resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"] // suggested by github
}

data "aws_iam_policy_document" "oidc_github" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringLike"
      values   = ["repo:kvcpr/terraform-demo"]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

resource "aws_iam_role" "github_oidc" {
  name               = "${var.BASE_NAME}-github_oidc-role"
  assume_role_policy = data.aws_iam_policy_document.oidc_github.json
}

data "aws_iam_policy_document" "ci" {
  statement {
    effect = "Allow"
    actions = ["iam:PassRole"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = ["lambda:*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = ["arn:aws:s3:::kp-tf-demo-terraform-state"]
  }

  statement {
    effect = "Allow"
    actions = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::kp-tf-demo-terraform-state/*"]
  }
}

resource "aws_iam_policy" "ci" {
  name        = "${var.BASE_NAME}-ci-policy"
  description = "Policy used for deployments on CI"
  policy      = data.aws_iam_policy_document.ci.json
}

resource "aws_iam_role_policy_attachment" "attach_ci_policy" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = aws_iam_policy.ci.arn
}
