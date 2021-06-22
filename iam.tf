data "aws_iam_policy_document" "access_key_policy_document" {

  for_each = var.user_names

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
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${each.value}"
    ]
  }
}

resource "aws_iam_policy" "access_keys_policy" {

  for_each = var.user_names

  name_prefix = "${each.value}-AccessKeyPolicy"
  policy      = data.aws_iam_policy_document.access_key_policy_document[each.key].json
}

resource "aws_iam_user_policy_attachment" "attach_access_key_policy" {

  for_each = var.user_names

  user       = each.value
  policy_arn = aws_iam_policy.access_keys_policy[each.key].arn
}