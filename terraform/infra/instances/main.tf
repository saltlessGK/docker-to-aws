resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.frontend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "frontend-instance"
  }
}

resource "aws_instance" "backend" {
  ami           = var.ami_id
  instance_type = "t3.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.backend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "backend-instance"
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

output "frontend_address" {value = aws_instance.frontend.public_ip}
output "backend_address" {value = aws_instance.backend.public_ip}
output "backend_private_address" {value = aws_instance.backend.private_ip}
output "db_address" {value = aws_instance.db.public_ip}
output "db_private_address" {value = aws_instance.db.private_ip}