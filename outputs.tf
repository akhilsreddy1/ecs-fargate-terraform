output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "ecs_cluster_name" {
  value       = aws_ecs_cluster.dev-ecs.arn
  description = "ECS cluster"
}

output "dnsname_alb" {
  description = "DNS name of ALB"
  value       = aws_alb.wordpressalb.dns_name
}