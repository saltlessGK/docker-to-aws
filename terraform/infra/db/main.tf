resource "aws_instance" "db" {
  ami           = var.ami_id
  instance_type = "t2.micro"

  key_name        = var.ssh_public_key
  vpc_security_group_ids = [var.db_sg_id]

  user_data_replace_on_change = true

  tags = {
    Terraform = "true"
    Name = "db-instance"
  }
}

output "public_addresses" {
  value = {
    public_hostname   = aws_instance.db.public_dns,
    public_ip_address = aws_instance.db.public_ip
  }
}