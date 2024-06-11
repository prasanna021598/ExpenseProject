output "aws_availability_zones" {
  value = data.aws_availability_zones.aws_zone.names
}

output "vpc_id" {
  value = aws_vpc.first_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "database_subnet_ids" {
  value = aws_subnet.database[*].id
}

output "database_subnet_group_ids" {
  value = aws_db_subnet_group.default[*].id
}

