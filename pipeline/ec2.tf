variable "instance_type" {
  description = "EC2 instance type (Graviton, to match the arm64 AMI)"
  type        = string
  default     = "t4g.micro"
}

# Latest Amazon Linux 2023 for arm64
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-arm64"]
  }
}

# Access through SSM Session Manager instead of SSH: no key pair, no open ports
resource "aws_iam_role" "ec2" {
  name = "secure-pipeline-ec2"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "secure-pipeline-ec2"
  role = aws_iam_role.ec2.name
}

resource "aws_instance" "app" {
  ami                  = data.aws_ami.al2023.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ec2.name
  monitoring           = true
  ebs_optimized        = true

  metadata_options {
    http_tokens = "required" # IMDSv2 only
  }

  root_block_device {
    encrypted = true
  }

  tags = { Name = "secure-pipeline-ec2" }

  lifecycle {
    ignore_changes = [ami] # a new AMI release shouldn't replace the running instance
  }
}
