data "aws_iam_policy_document" "access_key_policy_document" {

  policy_id = "${var.user_name}AccessKeyPolicy"

  statement {
    sid    = "ManageOwnIAMKeys"
    effect = "Allow"

    actions = [
      "iam:CreateAccessKey",
      "iam:DeleteAccessKey",
      "iam:GetAccessKeyLastUsed",
      "iam:GetUser",
      "iam:ListAccessKeys",
      "iam:UpdateAccessKey"
    ]

    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${var.user_name}"
    ]
  }
}

resource "aws_iam_policy" "access_keys_policy" {

  name        = "${var.user_name}-AccessKeyPolicy"
  policy      = data.aws_iam_policy_document.access_key_policy_document.json
}

resource "aws_iam_user_policy_attachment" "attach_access_key_policy" {

  user       = var.user_name
  policy_arn = aws_iam_policy.access_keys_policy.arn
}