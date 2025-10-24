terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-s4035894"
    key     = "./terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

locals {
  allowed_cidrs = var.allow_all_ip_addresses_to_db_server ? ["0.0.0.0/0"] : ["${var.ip_address}/32"]
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "admin" {
  key_name   = "admin-key"
  public_key = file(var.ssh_public_key)
}

module "security_groups" {
  source = "./infra/security_groups"
  allowed_cidrs = local.allowed_cidrs
}

module "instances" {
  source = "./infra/instances"
  ami_id = data.aws_ami.ubuntu.id
  ssh_public_key = aws_key_pair.admin.key_name
  frontend_sg_id = module.security_groups.frontend_sg_id
  backend_sg_id = module.security_groups.backend_sg_id
  db_sg_id = module.security_groups.db_sg_id
}
module "load_balancers" {
  source = "./infra/load_balancers"
  frontend_alb_sg_id = module.security_groups.frontend_alb_sg_id
  backend_alb_sg_id = module.security_groups.backend_alb_sg_id
  frontend_1_id = module.instances.frontend_1_id
  frontend_2_id = module.instances.frontend_2_id
  backend_1_id = module.instances.backend_1_id
  backend_2_id = module.instances.backend_2_id
}

resource "local_file" "inventory" {
  content = templatefile("${path.module}/../ansible/inventory.tpl", {
    frontend_alb_dns = module.load_balancers.frontend_alb_dns_name
    backend_alb_dns = module.load_balancers.backend_alb_dns_name
    frontend_ip_1 = module.instances.frontend_1_address
    frontend_ip_2 = module.instances.frontend_2_address
    backend_ip_1 = module.instances.backend_1_address
    backend_private_ip_1 = module.instances.backend_1_private_address
    backend_ip_2 = module.instances.backend_2_address
    backend_private_ip_2 = module.instances.backend_2_private_address
    db_ip = module.instances.db_address
    db_private_ip = module.instances.db_private_address
  })
  filename = "${path.module}/../ansible/inventory.yml"
}

output "app_dns" {value = module.load_balancers.frontend_alb_dns_name}