resource "aws_iam_role" "node" {
  name               = "${var.prefix}-${var.cluster_name}-role-node"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement":[
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ] 
}
POLICY
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.node.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

data "aws_ec2_instance_type" "instance_type" {
  instance_type = "t2.micro"
}


output "instance-type" {
  value = data.aws_ec2_instance_type.instance_type.instance_type
}


resource "aws_eks_node_group" "node-1" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "node-1"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.subnets[*].id
  instance_types  = [data.aws_ec2_instance_type.instance_type.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy
  ]
}


resource "aws_eks_node_group" "node-2" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "node-2"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = aws_subnet.subnets[*].id
  instance_types  = [data.aws_ec2_instance_type.instance_type.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy
  ]
}
