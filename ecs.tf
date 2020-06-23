 resource "aws_ecs_cluster" "dev-ecs" {
  name               = "dev-ecs"
  capacity_providers = ["FARGATE"]

  #default_capacity_provider_strategy {
  #      capacity_provider = "FARGATE_SPOT"
  #      weight
  #}
  tags = {
    environemt = "Dev"
  }
}

# When you use the awsvpc network mode in your task definitions, every task that is launched from that task definition gets its own elastic network interface (ENI) and a primary private IP address.

data "template_file" "wordpress" {
  template = file("files/taskdef.json")
  vars = {
    aws_region     = tostring(data.aws_region.current.name)
  }
}

resource "aws_ecs_task_definition" "ecs_taskdef" {
  family                   = "micro-app"
  #container_definitions    = data.template_file.wordpress.rendered
  container_definitions    = templatefile("files/taskdef.json",{aws_region = tostring(data.aws_region.current.name)})
  network_mode             = "awsvpc" # mandatory for fargate
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  execution_role_arn       = aws_iam_role.ecs_taskexecution_role.arn
  task_role_arn            = aws_iam_role.ecs_taskexecution_role.arn
}
  
resource "aws_ecs_service" "wordpress" {
  name            =  var.service_name
  cluster         = aws_ecs_cluster.dev-ecs.id
  task_definition = aws_ecs_task_definition.ecs_taskdef.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"
  #iam_role = aws_iam_role.ecs_service_role.arn
  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          = data.aws_subnet_ids.publicsubnets.ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-target-group.id
    container_name   = "wordpress"
    container_port   = 80
  }

  depends_on = [aws_ecs_cluster.dev-ecs, aws_ecs_task_definition.ecs_taskdef, aws_alb_listener.alb-listener]
}


# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-security-group"
  description = "allow inbound access from the ALB only"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    security_groups = [aws_security_group.alb-sg.id]
  }

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [aws_security_group.alb-sg.id]
  }


  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
