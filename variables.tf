variable "user_names" {
  description = "Array of IAM users to whom this policy should be applied"
  type        = set(string)
}
