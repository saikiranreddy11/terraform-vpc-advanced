
VPC
This module is going to create

VPC

Internet gateway

2 Public subnets

2 Private subnets

2 Database subnets

subnet associations

Route Tables

NAT Gateway

Internet gateway

Grouping the database subnets

Inputs

projectname(optional) - default project name is roboshop

vpc_cidr_block(Required) - User has to provide cidr block

enable_dns_hostnames(required) - User can provide enable_dns_hostnames, default is true

enable_dns_support(required) - User can provide enable_dns_support, default is true


common_tags(Optional) - User can provide common tags for all resources, default is empty.

vpc_tags(Optional) - User can provide vpc tags for vpc resources, default is empty.

gw_tags(Optional) - User can provide internet gateway tags for internet gateway resources, default is empty.

public_cidr_block(Required) - User must provide a list of 2 public subnet CIDR.

az(optional) - User must provide 2 az.

private_cidr_block(Required) - User must provide a list of 2 private subnet CIDR.

database_cidr_block(Required) - User must provide a list of 2 database subnet CIDR.

This is not a perfect documentation 