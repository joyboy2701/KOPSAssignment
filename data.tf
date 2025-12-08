data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.kops_cluster_config.vpc_id]
  }

  tags = {
    Name = "*public*"
  }
}

# Fetch all private subnets in the VPC
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.kops_cluster_config.vpc_id]
  }

  tags = {
    Name = "*private*"
  }
}

# Get details for each subnet (to extract AZ information)
data "aws_subnet" "public_details" {
  for_each = toset(data.aws_subnets.public.ids)
  id       = each.value
}

data "aws_subnet" "private_details" {
  for_each = toset(data.aws_subnets.private.ids)
  id       = each.value
}
