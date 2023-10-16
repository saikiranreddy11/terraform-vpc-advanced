variable "vpc_cidr_block"{

}
variable "projectname"{
    default = "roboshop"
}
variable "common_tags"{
   default ={}
}

variable "env"{
  
}
variable "vpc_tags"{
   default ={}
}

variable "enable_dns_hostnames"{
    
}

variable "enable_dns_support"{
    
}

variable "gw_tags"{
   default ={}
}

variable "az"{
    #type= list(string)
    default = ["us-east-1a", "us-east-1b"]
 validation {
    condition  =  var.az == ["us-east-1a", "us-east-1b"] || var.az == ["us-east-1b", "us-east-1a"]

    error_message = "you are allowed to create the resources only in us-east-1a and us-east-1b."
  }
}


variable "public_cidr_block"{
validation {
    condition  =  length(var.public_cidr_block)==2

    error_message = "please enter only the two public cidr blocks"
  }
}

variable "private_cidr_block"{
validation {
    condition  =  length(var.private_cidr_block)==2

    error_message = "please enter only the two private cidr blocks"
  }
}

variable "database_cidr_block"{
validation {
    condition  =  length(var.database_cidr_block)==2

    error_message = "please enter only the two database cidr blocks"
  }
}


# variable "public_subnet_cidr" {
#   description = "VPC private subnet ids."
#   type        = list(string)

#   validation {
#     condition     = length(var.az) == 2
#     error_message = "please enter the two subnets."
#   }
# }

variable "public_route"{
    default ="0.0.0.0/0"
}


variable public_routetable_tags{
 default ={}
}
variable private_routetable_tags{
 default ={}
}
variable database_routetable_tags{
 default ={}
}

variable db_subnet_group_tags{
  default = {}
}

variable peer_vpc_id{
  default = ""
}

variable peer_cidr_block{
  default=""
}

variable "is_peering_connection"{
  default = false
}