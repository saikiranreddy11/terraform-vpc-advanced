VPC
This module is going to create

VPC
Internet gateway
2 Public subnets
2 Private subnets
2 Database subnets
Public Route table
Private Route table
Database Route table
EIP
NAT Gateway
Database subnet grouping
subnet associations to the route tables

Inputs
projectname(optional) - The default project name is roboshop
vpc_cidr_block(Required) - User has to provide cidr block
enable_dns_hostnames(Required) - User can provide enable_dns_hostnames, default is true
enable_dns_support(Required) - User can provide enable_dns_support, default is true
common_tags(Optional) - User can provide common tags for all resources, default is empty.
vpc_tags(Optional) - User can provide vpc tags for vpc resources, default is empty.
gw_tags(Optional) - User can provide internet gateway tags for internet gateway resources, default is empty.
public_cidr_block(Required) - User must provide a list of 2 public subnet CIDR.
az(optional) - User must provide 2 az.
private_cidr_block(Required) - User must provide a list of 2 private subnet CIDR.
database_cidr_block(Required) - User must provide a list of 2 database subnet CIDR.

