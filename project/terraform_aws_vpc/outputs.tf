output "aws_availability_zones" {
  value = data.aws_availability_zones.aws_zone.names
}
