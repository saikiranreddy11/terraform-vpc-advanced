# terraform-vpc-advanced
This is the module to create a complete setup of VPC, public, private,database subnets,route tables,NAT gateway,subnet associations and routes  in the only two avalilability zones(1a,1b).
  vpc_cidr_block(mandatory)
    common_tags = var.common_tags
    vpc_tags = var.vpc_tags
    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support
     gw_tags = var.gw_tags
    # az = var.az
    projectname= var.projectname
    public_cidr_block = var.public_cidr_block
    private_cidr_block = var.private_cidr_block
    database_cidr_block = var.database_cidr_block



VPC
This module is going to create

VPC
Internet gateway
2 Public subnets
2 Private subnets
2 Database subnets
subnet associations
Inputs
cidr_block(Required) - User has to provide cidr block
enable_dns_hostnames(required) - User can provide enable_dns_hostnames, default is true
enable_dns_support(required) - User can provide enable_dns_support, default is true
common_tags(Optional) - User can provide common tags for all resources, default is empty.
vpc_tags(Optional) - User can provide vpc tags for vpc resources, default is empty.
gw_tags(Optional) - User can provide internet gateway tags for internet gateway resources, default is empty.
public_subnet_cidr(Required) - User must provide a list of 2 public subnet CIDR.
az(optional) - User must provide 2 az.
private_subnet_cidr(Required) - User must provide a list of 2 private subnet CIDR.
database_subnet_cidr(Required) - User must provide a list of 2 database subnet CIDR.

