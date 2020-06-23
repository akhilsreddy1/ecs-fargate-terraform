data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_subnet_ids" "publicsubnets" {
  vpc_id = data.aws_vpc.selected.id
}


data "aws_kms_alias" "s3kms" {
  name = "alias/aws/s3"
}