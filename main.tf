resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_block}"

  tags {
    Name = "openvpn-gw"
  }
}

resource "aws_subnet" "vpn_subnet" {
  vpc_id                  = "${aws_vpc.main.id}"
  map_public_ip_on_launch = true
  cidr_block              = "${var.subnet_cidr_block}"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "Internet Gateway for openvpn"
  }
}

resource "aws_eip" "openvpn_gw_eip" {
  vpc        = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_route" "internet_access_openvpn_gw" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_route" "destination_cidr_block" {
  route_table_id         = "${aws_vpc.main.main_route_table_id}"
  destination_cidr_block = "${var.access_server_cidr_block}"
  instance_id            = "${aws_instance.openvpn_gw.id}"
}
resource "aws_security_group" "openvpn_gw" {
  name        = "openvpn-gw_sg"
  description = "Allow traffic needed by openvpn"
  vpc_id      = "${aws_vpc.main.id}"

  // Custom ICMP Rule - IPv4 Echo Reply
  ingress {
    from_port   = "0"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  // Custom ICMP Rule - IPv4 Echo Request
  ingress {
    from_port   = "8"
    to_port     = "-1"
    protocol    = "icmp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  // ssh
  ingress {
    from_port   = "${var.ssh_port}"
    to_port     = "${var.ssh_port}"
    protocol    = "tcp"
    cidr_blocks = ["${var.ssh_cidr}"]
  }

  // all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_eip_association" "vpn_gw_eip_assoc" {
  instance_id   = "${aws_instance.openvpn_gw.id}"
  allocation_id = "${aws_eip.openvpn_gw_eip.id}"
}

resource "aws_key_pair" "openvpn_gw" {
  key_name   = "openvpn-gw-key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_instance" "openvpn_gw" {
  tags {
    Name = "openvpn-gw"
  }

  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${aws_key_pair.openvpn_gw.key_name}"
  subnet_id                   = "${aws_subnet.vpn_subnet.id}"
  vpc_security_group_ids      = ["${aws_security_group.openvpn_gw.id}"]
  associate_public_ip_address = true
  source_dest_check           = false
}

resource "aws_route" "subsidiary_network_route_add" {
  route_table_id         = "${var.vpn_access_server_main_route_table_id}"
  destination_cidr_block = "${var.vpc_cidr_block}"
  instance_id            = "${var.vpn_access_server_instance_id}"
}