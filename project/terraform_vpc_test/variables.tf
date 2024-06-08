variable "common_tags" {
  default = {
    Project = "Expense"
    Environment = "Dev" 
    Terraform = true
  }
}

variable "project_name" {
    default = "Expense-Project"
}

variable "environment" {
    default = "dev"
}

variable "public_subnet_cidrs" {
  default = ["10.0.0.0/24" , "10.0.1.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.3.0/24" , "10.0.4.0/24"]
}

variable "database_subnet_cidrs" {
  default = ["10.0.8.0/24" , "10.0.9.0/24"]
}
