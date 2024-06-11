### VPC Variables #######

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "enable_dns_hostnames" {
    type = bool
    default = true 
}

#### Project variables ####

variable "project_name" {
  type = string
}

variable "environment" {
    type = string
}

variable "common_tags" {
  type = map
}


variable "vpc_tags" {
  type = map 
  default = {}
}


##### IGW ###########

variable "IGW_tags" {
  type = map
  default = {} 
}

######Public subnet #########

variable "public_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.public_subnet_cidrs) == 2
    error_message = "please provide 2 valid public subnet cidr"
  }
}

###### Private subnet #########

variable "private_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.private_subnet_cidrs) == 2
    error_message = "please provide 2 valid private subnet cidr"
  }
}

###### Database subnet #########

variable "database_subnet_cidrs" {
  type = list
  validation {
    condition = length(var.database_subnet_cidrs) == 2
    error_message = "please provide 2 valid database subnet cidr"
  }
}


#### NAT Gateway Tags #########

variable "nat_gatewasy_tags" {
  type = map 
  default = {}
}

### Route table tags #####

variable "public_route_table_tags" {
  type = map
  default = {}
}
variable "private_route_table_tags" {
  type = map
  default = {}
}
variable "database_route_table_tags" {
  type = map
  default = {}
}


## Peering connection ########
 variable "peering_required" {
   type = bool
   default = false
 }

 variable "target_vpc_id" {
   type = string
   default = ""
 }

 variable "vpc_peering_tags" {
   type = map 
   default = {}
 }

 variable "database_subnet_group_tags" {
   type = map 
   default = {}
 }
