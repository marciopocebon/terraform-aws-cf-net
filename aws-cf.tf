provider "aws" {
	access_key = "${var.aws_access_key}"
	secret_key = "${var.aws_secret_key}"
	region = "${var.aws_region}"
}

resource "aws_subnet" "cfruntime-2a" {
	vpc_id = "${var.aws_vpc_id}"
	cidr_block = "${var.network}.${var.offset}3.0/24"
	tags {
		Name = "cf1"
	}
}

output "aws_subnet_cfruntime-2a_id" {
  value = "${aws_subnet.cfruntime-2a.id}"
}

resource "aws_security_group" "cf" {
	name = "cf-${var.offset}-${var.aws_vpc_id}"
	description = "CF security groups"
	vpc_id = "${var.aws_vpc_id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 4443
		to_port = 4443
		protocol = "tcp"
	}

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = 4222
		to_port = 25777
		protocol = "tcp"
	}

	ingress {
		cidr_blocks = ["0.0.0.0/0"]
		from_port = -1
		to_port = -1
		protocol = "icmp"
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "tcp"
		self = "true"
	}

	ingress {
		from_port = 0
		to_port = 65535
		protocol = "udp"
		self = "true"
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	tags {
		Name = "cf-${var.offset}-${var.aws_vpc_id}"
	}

}

output "aws_security_group_cf_name" {
  value = "${aws_security_group.cf.name}"
}

output "aws_security_group_cf_id" {
  value = "${aws_security_group.cf.id}"
}

resource "aws_eip" "cf" {
	vpc = true
}

output "aws_eip_cf_public_ip" {
  value = "${aws_eip.cf.public_ip}"
}

output "aws_cf_a_cidr" {
  value = "${aws_subnet.cfruntime-2a.cidr_block}"
}
