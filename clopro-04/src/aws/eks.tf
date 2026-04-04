resource "aws_eks_cluster" "eks_cluster" {
  name = "${local.name_prefix}-eks-cluster"

  access_config {
    authentication_mode = var.eks_auth_mode
  }

  role_arn = aws_iam_role.eks_cluster_role.arn
  version  = var.eks_version

  vpc_config {
    subnet_ids = [
      aws_subnet.public.id,
      aws_subnet.public_secondary.id,
      aws_subnet.public_tertiary.id,
    ]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

# data "aws_caller_identity" "current" {}

# EKS access entry managed manually (IAM user lacks eks:DescribeAccessEntry permission)
# resource "aws_eks_access_entry" "admin" {
#   cluster_name  = aws_eks_cluster.eks_cluster.name
#   principal_arn = var.eks_admin_principal_arn
#   type          = "STANDARD"
# }

# resource "aws_eks_access_policy_association" "admin" {
#   cluster_name  = aws_eks_cluster.eks_cluster.name
#   principal_arn = var.eks_admin_principal_arn
#   policy_arn    = var.eks_admin_policy_arn
#
#   access_scope {
#     type = "cluster"
#   }
#
#   depends_on = [aws_eks_access_entry.admin]
# }

resource "aws_iam_role" "eks_cluster_role" {
  name = "${local.name_prefix}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = local.iam_policy_version
    Statement = [
      {
        Action = local.iam_cluster_assume_actions
        Effect = local.iam_effect_allow
        Principal = {
          Service = var.eks_cluster_service_principal
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = var.eks_cluster_policy_arn
  role       = aws_iam_role.eks_cluster_role.name
}

# Node group

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${local.name_prefix}-eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids = [
    aws_subnet.public.id,
    aws_subnet.public_secondary.id,
    aws_subnet.public_tertiary.id,
  ]

  instance_types = [var.eks_node_instance_type]

  scaling_config {
    desired_size = var.eks_node_desired_size
    max_size     = var.eks_node_max_size
    min_size     = var.eks_node_min_size
  }

  update_config {
    max_unavailable = var.eks_node_max_unavailable
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node_group_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node_group_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node_group_AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "${local.name_prefix}-eks-node-group-role"
  assume_role_policy = jsonencode({
    Version = local.iam_policy_version
    Statement = [
      {
        Action = local.iam_node_assume_action
        Effect = local.iam_effect_allow
        Principal = {
          Service = var.eks_node_service_principal
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKSWorkerNodePolicy" {
  policy_arn = var.eks_node_worker_policy_arn
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEKS_CNI_Policy" {
  policy_arn = var.eks_node_cni_policy_arn
  role       = aws_iam_role.eks_node_group_role.name
}

resource "aws_iam_role_policy_attachment" "node_group_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = var.eks_node_ecr_policy_arn
  role       = aws_iam_role.eks_node_group_role.name
}