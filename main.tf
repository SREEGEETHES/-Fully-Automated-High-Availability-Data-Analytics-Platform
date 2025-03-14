provider "aws" {
  region     = "ap-south-1"
  
}


# Create S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = "sreegeethesh-terraform-bucket-2025"
}

resource "aws_s3_bucket_ownership_controls" "my_bucket_ownership" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "my_bucket_public_access" {
  bucket = aws_s3_bucket.my_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "my_bucket_encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Security Group for EC2 & EKS
resource "aws_security_group" "my_sg" {
  name        = "eks-security-group"
  description = "Allow SSH, HTTP, and Kubernetes API"
  vpc_id      = "vpc-0ef7af3a58e2ad424"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Kubernetes API"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 Instance
resource "aws_instance" "my_ec2" {
  ami                    = "ami-08fe5144e4659a3b3"
  instance_type          = "t3.medium"
  subnet_id              = "subnet-039375f93de7d4f22"
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = { 
    Name = "Updated-EC2-Instance" 
  }
}

# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_role" {
  name = "eksClusterRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_role_attachment" {
  role       = aws_iam_role.eks_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# IAM Role for Worker Nodes
resource "aws_iam_role" "eks_node_role" {
  name = "eksNodeRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Create EKS Cluster
resource "aws_eks_cluster" "my_eks" {
  name     = "sreegeethesh-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config { 
    subnet_ids = ["subnet-039375f93de7d4f22", "subnet-0c709baa0f407d5a8"]  # ✅ Fixed the two AZs issue
  }
  
  depends_on = [aws_iam_role_policy_attachment.eks_role_attachment]
}

# Create EKS Worker Nodes
resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.my_eks.name
  node_group_name = "eks-worker-nodes"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = ["subnet-039375f93de7d4f22", "subnet-0c709baa0f407d5a8"]  # ✅ Fixed AZ issue
  instance_types  = ["t3.medium"]

  scaling_config {
    desired_size = 2
    min_size     = 1
    max_size     = 3
  }
}

# Output EKS Cluster Name
output "eks_cluster_name" {
  value = aws_eks_cluster.my_eks.name
}

# Output EC2 Public IP
output "ec2_public_ip" {
  value = aws_instance.my_ec2.public_ip
}
