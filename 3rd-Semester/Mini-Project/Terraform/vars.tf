# Creating an aws_VPC
variable "cidr_block" {
  type    = string
  default = "10.0.0.0/16"

}

variable "public_subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]

}
variable "availability_zone" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]

}

variable "private_subnet_cidr" {
  type    = list(string)
  default = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]

}

# Creating a Variable for ami of type map
variable "ami" {
  type    = string
  default = "ami-00874d747dde814fa"
}

# Creating a Variable for instance_type
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "zone_id" {
  default = "Z08078261URAXKEGBNRYX"
}
