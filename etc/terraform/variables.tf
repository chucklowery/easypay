variable "aws_region" {
   default = "us-east-1"
}

variable "vpc_cidr" {
   default = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
   default = "10.20.1.0/24"
}

variable "az" {
   default = "us-east-1a"
}

variable "instance_ami" {
  default = "ami-09e67e426f25ce0d7"
}

variable "instance_type" {
  default = "t2.medium"
}

