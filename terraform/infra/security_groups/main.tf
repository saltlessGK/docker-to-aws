resource "aws_security_group" "frontend" {
  name = "frontend-sg"
  description = "Allow global HTTP access"

  # SSH (Manual) in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # SSH (EC2 Connect) in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = ["pl-0e4bcff02b13bef1e"]
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "frontend-sg"
  }
}

resource "aws_security_group" "backend" {
  name = "backend-sg"
  description = "Allow HTTP access from frontend"

  # SSH in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # SSH (EC2 Connect) in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = ["pl-0e4bcff02b13bef1e"]
  }
  
  # HTTP in
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "backend-sg"
  }
}

resource "aws_security_group" "db" {
  name = "db-sg"
  description = "Allow PostgreSQL access from backend"

  # SSH in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  # SSH (EC2 Connect) in
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    prefix_list_ids = ["pl-0e4bcff02b13bef1e"]
  }

  # PostgreSQL in
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

output "frontend_sg_id" {value = aws_security_group.frontend.id}
output "backend_sg_id"  {value = aws_security_group.backend.id}
output "db_sg_id" {value = aws_security_group.db.id}