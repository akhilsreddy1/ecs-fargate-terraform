resource "aws_alb" "wordpressalb" {
  name                       = "wordpressalb"
  internal                   = false
  subnets                    = data.aws_subnet_ids.publicsubnets.ids
  security_groups            = [aws_security_group.alb-sg.id]
  enable_deletion_protection = true
  tags = {
    Environment = "production"
  }
}
resource "aws_alb_target_group" "ecs-target-group" {
  name        = "ecs-target-group"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.selected.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "7"
    unhealthy_threshold = "7"
    interval            = "120"
    matcher             = "200"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
  }
  tags = {
    Name = "ecs-target-group"
  }
}
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.wordpressalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs-target-group.arn
    type             = "forward"
  }
}

# ingress 80/8080 from external
resource "aws_security_group" "alb-sg" {
  name        = "alb-load-balancer-security-group"
  description = "controls access to the ALB"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "http from VPC"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http from VPC"
    protocol    = "tcp"
    from_port   = 8080
    to_port     = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
