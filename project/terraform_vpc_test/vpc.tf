module "vpc"{
    source = "../terraform_aws_vpc"
    project_name = var.project_name
    common_tags = var.common_tags
    environment = var.environment
    public_subnet_cidrs = var.public_subnet_cidrs
    private_subnet_cidrs = var.private_subnet_cidrs
    database_subnet_cidrs = var.database_subnet_cidrs
    peering_required = var.peering_required
}
