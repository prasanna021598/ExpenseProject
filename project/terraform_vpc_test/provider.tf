terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.52.0"
    }
  }

backend "s3" {
    bucket = "terraform-practice15"
    key    = "expense_vpc_subnets_sa"
    dynamodb_table = "Dynamotableterraform"
    region = "us-east-1"
}
}

provider "aws" {
  # Configuration options
}