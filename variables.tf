variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "aws_region" {
  default = "us-east-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "access_server_cidr_block" {}

variable "vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "subnet_cidr_block" {
  default = "10.10.0.0/16"
}

variable "ssh_user" {
  default = "ubuntu"
}

variable "ssh_port" {
  default = 22
}

variable "ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "ami" {
  default = "ami-0680fd63c2ddf7411" // ubuntu xenial openvpn gateway ami in eu-east-2
}

variable "vpn_access_server_main_route_table_id" {}

variable "vpn_access_server_instance_id" {}

