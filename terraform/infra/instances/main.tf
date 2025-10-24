resource "aws_instance" "frontend_1" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.frontend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "frontend-instance-1"
  }
}

resource "aws_instance" "frontend_2" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.frontend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "frontend-instance-2"
  }
}

resource "aws_instance" "backend_1" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.backend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "backend-instance-1"
  }
}

resource "aws_instance" "backend_2" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.backend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "backend-instance-2"
  }
}

resource "aws_instance" "db" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.db_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "db-instance"
  }
}

#Frontend Instances
output "frontend_1_address" {value = aws_instance.frontend_1.public_ip}
output "frontend_1_id" {value = aws_instance.frontend_1.id}
output "frontend_2_address" {value = aws_instance.frontend_2.public_ip}
output "frontend_2_id" {value = aws_instance.frontend_2.id}

#Backend Instances
output "backend_1_address" {value = aws_instance.backend_1.public_ip}
output "backend_1_private_address" {value = aws_instance.backend_1.private_ip}
output "backend_1_id" {value = aws_instance.backend_1.id}
output "backend_2_address" {value = aws_instance.backend_2.public_ip}
output "backend_2_private_address" {value = aws_instance.backend_2.private_ip}
output "backend_2_id" {value = aws_instance.backend_2.id}

#Database Instance
output "db_address" {value = aws_instance.db.public_ip}
output "db_private_address" {value = aws_instance.db.private_ip}