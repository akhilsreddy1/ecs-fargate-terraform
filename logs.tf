
resource "aws_cloudwatch_log_group" "wordpress" {
  name              = "/ecs/wordpress"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "wordpress" {
  name           = "wordpress"
  log_group_name = aws_cloudwatch_log_group.wordpress.name
}



resource "aws_cloudwatch_log_group" "wordpresssql" {
  name              = "/ecs/wordpresssql"
  retention_in_days = 30
}

resource "aws_cloudwatch_log_stream" "wordpresssql" {
  name           = "wordpresssql"
  log_group_name = aws_cloudwatch_log_group.wordpresssql.name
}

