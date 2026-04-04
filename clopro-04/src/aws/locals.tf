locals {
  name_prefix                = "${var.project}-${var.env}"
  iam_policy_version         = "2012-10-17"
  iam_effect_allow           = "Allow"
  iam_cluster_assume_actions = ["sts:AssumeRole", "sts:TagSession"]
  iam_node_assume_action     = "sts:AssumeRole"
}
