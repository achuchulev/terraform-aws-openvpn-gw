output "vpn_gw_public_ip" {
  value = "${aws_eip_association.vpn_gw_eip_assoc.public_ip}"
}
