### VPC module to create vpc
provider "aws" {
  region = var.AWS_REGION
}

data "aws_vpc" "default" {
  default = true
} 




resource "aws_instance" "node" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = "t2.medium"
  associate_public_ip_address = true
  #for_each      = data.aws_subnet_ids.selected.ids
  #iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  # the VPC subnet
  #subnet_id = module.vpc.public_subnets[0]

  # the security group
  vpc_security_group_ids = [aws_security_group.k3s-sec-grp.id]

  # the public SSH key
  key_name = aws_key_pair.mykeypair.key_name
  user_data = local.template_file_int

  tags = {
    Name = "docker-node"
    type = "terraform"
  }
}


locals {
   template_file_int  = templatefile("./install.tpl", {})
}

