
variable "aws_region" {
  default = "us-west-2"
}

variable "ecs_task_execution_role_name" {
  description = "ECS task execution role name"
  default     = "ecs_task_execution_role"
}
variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default     = "1024"
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default     = "2048"
}

variable "vpc_id" {
  default = "vpc-c8b339b0"
}

variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}

variable "service_name" {
  type        = string
  default     = "wordpress"
}