data "aws_subnet" "subnet_1" {
  filter {
    name   = "availabilityZone"
    values = ["us-east-1c"]
  }
  vpc_id = "vpc-00b23d89beb05eb48"
}

data "aws_subnet" "subnet_2" {
  filter {
    name   = "availabilityZone"
    values = ["us-east-1d"]
  }
  vpc_id = "vpc-00b23d89beb05eb48"
}

resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.frontend_alb_sg_id]
  subnets = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = "vpc-00b23d89beb05eb48"
}

resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}

resource "aws_lb_target_group_attachment" "frontend_1" {
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = var.frontend_1_id
  port             = 8081
}

resource "aws_lb_target_group_attachment" "frontend_2" {
  target_group_arn = aws_lb_target_group.frontend.arn
  target_id        = var.frontend_2_id
  port             = 8081
}

#--------------------------------------------------------------

resource "aws_lb" "backend" {
  name               = "backend-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.backend_alb_sg_id]
  subnets = [data.aws_subnet.subnet_1.id, data.aws_subnet.subnet_2.id]
}

resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-00b23d89beb05eb48"
}

resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.backend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}

resource "aws_lb_target_group_attachment" "backend_1" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = var.backend_1_id
  port             = 8080
}

resource "aws_lb_target_group_attachment" "backend_2" {
  target_group_arn = aws_lb_target_group.backend.arn
  target_id        = var.backend_2_id
  port             = 8080
}

output "frontend_alb_dns_name" {value = aws_lb.frontend.dns_name}
output "backend_alb_dns_name" {value = aws_lb.backend.dns_name}