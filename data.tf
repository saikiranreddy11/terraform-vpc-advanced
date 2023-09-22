data "aws_availability_zones" "available" {
  state = "available"  # Optional, you can specify "available", "information", or "unavailable"
}