resource "aws_instance" "frontend" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.frontend_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "frontend-instance"
  }
}

output "public_addresses" {
  value = {
    public_hostname   = aws_instance.frontend.public_dns,
    public_ip_address = aws_instance.frontend.public_ip
  }
}