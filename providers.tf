# Configure the AWS provider
provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.vpn_gw_aws_region}"

  version = "< 2.0.0"
}
