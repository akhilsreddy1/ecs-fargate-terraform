
data "aws_iam_policy_document" "ecsservicerolepolicy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-manage-policy-attachment" {
  role       = aws_iam_role.ecs_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_iam_role" "ecs_service_role" {
  name               = "ecs_service_role"
  assume_role_policy = data.aws_iam_policy_document.ecsservicerolepolicy.json
  tags = {
    role = "ecs-service"
  }
}

# ECS task execution role data
data "aws_iam_policy_document" "ecstaskrolepolicy" {
  version = "2012-10-17"
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# ECS task execution role
resource "aws_iam_role" "ecs_taskexecution_role" {
  name               = var.ecs_task_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.ecstaskrolepolicy.json
}

# ECS task execution role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_taskexecution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "execution_role" {
  
  statement {
    sid    = "AllowECR"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:*"
    ]

    resources = ["*"]
  }
  
  statement {
      sid    = "AllowLogging"
      effect = "Allow"

  actions = [
			"logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents"
		]

		 resources = ["*"]
	}
  
  statement {
    sid = "AllowS3"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "execution_role" {
  role   = aws_iam_role.ecs_taskexecution_role.name
  policy = data.aws_iam_policy_document.execution_role.json
}
