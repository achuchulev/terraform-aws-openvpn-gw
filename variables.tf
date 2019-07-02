variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "vpn_gw_aws_region" {
  default = "us-east-2"
}

variable "vpn_gw_instance_type" {
  default = "t2.micro"
}

variable "access_server_cidr_block" {}

variable "vpn_gw_vpc_cidr_block" {
  default = "10.10.0.0/16"
}

variable "vpn_gw_subnet_cidr_block" {
  default = "10.10.0.0/16"
}

variable "vpn_gw_ssh_user" {
  default = "ubuntu"
}

variable "vpn_gw_ssh_port" {
  default = 22
}

variable "vpn_gw_ssh_cidr" {
  default = "0.0.0.0/0"
}

variable "vpn_gw_ami" {
  default = "ami-0680fd63c2ddf7411" // ubuntu xenial openvpn gateway ami in eu-east-2
}
