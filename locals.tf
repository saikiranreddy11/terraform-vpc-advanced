locals {
  allowed_availability_zones = [
    element(data.aws_availability_zones.available.names, 0),  # us-east-1a
    element(data.aws_availability_zones.available.names, 1),  # us-east-1b
  ]
}

#use can also use the following slice function to get the two availability zones 
# locals {
#   available_zones = data.aws_availability_zones.available.names
#   allowed_availability_zones = slice(local.available_zones, 0, 2) # Selects the first two zones (0-based index)
# }




# locals {
#     valid_az=length(var.az)==2

# }
