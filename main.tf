variable "aws_region" {
  default = "us-east-1"
  description = "Required: Name of the region this cluster will be created in"
}

variable "subnet_id" {
  description = "Required: ID of the subnet this cluster will be created in"
}

variable "ssh_public_key_name" {
  description = "Required: Name of a public key entry in AWS to be deployed to each instance"
}

variable "ami_id" {
  default     = ""
  description = "Optional: The ID of the AMI used to launch instances; defaults to the latest CentOS 7 image"
}

variable "instance_count" {
  default     = "1"
  description = "Optional: Number of EC2 instances in the cluster"
}

variable "instance_type" {
  description = "Required: AWS instance type for instances in the cluster"
}

variable "vpc_security_group_id" {
  description = "Required: ID of the security group this cluster will be created in"
}

provider "aws" {
  region = "${var.aws_region}"
}

data "aws_ami" "centos" {
  owners      = ["679593333241"]
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

module "ec2_cluster" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name           = "my-instance"
  instance_count = "${var.instance_count}"

  ami           = "${var.ami_id != "" ? var.ami_id : data.aws_ami.centos.id}"
  instance_type = "t2.small"
  #iam_instance_profile   = "${aws_iam_instance_profile.main.id}"
  key_name               = "${var.ssh_public_key_name}"
  vpc_security_group_ids = ["${var.vpc_security_group_id}"]
  subnet_ids             = ["${var.subnet_id}"]

  tags = {
    "owner" = "Craig Sands"
  }
}

output "private_ips" {
  description = "List of private IP addresses assigned to the instances"
  value       = ["${module.ec2_cluster.private_ip}"]
}
