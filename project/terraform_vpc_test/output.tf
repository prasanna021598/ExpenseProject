output "azs_info" {
  value = module.vpc.aws_availability_zones
}

output "vpc" {
  value = module.vpc.vpc_id
}

output "public_subnet_list" {
  value = module.vpc.public_subnet_ids
}

# output "igw_id" {
#   value = module.vpc.igw_id
# }


