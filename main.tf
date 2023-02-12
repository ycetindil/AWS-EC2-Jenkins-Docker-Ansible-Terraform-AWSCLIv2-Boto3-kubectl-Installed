terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    github = {
      source  = "integrations/github"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "github" {
  token = file("github_token")
}

resource "aws_iam_role" "aws_access" {
  name = "jenkins-project-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess", "arn:aws:iam::aws:policy/AmazonEC2FullAccess", "arn:aws:iam::aws:policy/IAMFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]

}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "jenkins-project-profile"
  role = aws_iam_role.aws_access.name
}

resource "aws_instance" "jenkins-server" {
  ami                    = var.myami
  instance_type          = var.instancetype
  key_name               = var.mykey
  vpc_security_group_ids = [aws_security_group.jenkins-sec-gr.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2-profile.name
  tags = {
    Name = var.tag
  }
  user_data = file("jenkins.sh")

}

resource "aws_security_group" "jenkins-sec-gr" {
  name = var.jenkins-sg
  tags = {
    Name = var.jenkins-sg
  }

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    protocol    = "tcp"
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = -1
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_s3_bucket" "jenkins-bucket" {
  bucket = "jenkins-project-2-11-2023"

  tags = {
    Name = "Jenkins-project"
  }
}

resource "aws_s3_bucket_acl" "jenkins-acl" {
  bucket = aws_s3_bucket.jenkins-bucket.id
  acl    = "private"
}

resource "github_repository" "git_repo" {
  name       = "Jenkins-project"
  visibility = "public"
  auto_init  = true
}

resource "null_resource" "git_clone" {
  provisioner "local-exec" {
    command = "git clone https://github.com/oguzhanaydogan/${github_repository.git_repo.name}.git ../${github_repository.git_repo.name}"
  }
}