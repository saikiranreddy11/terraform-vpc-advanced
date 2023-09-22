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
