resource "aws_instance" "open_vpn" {
  ami = "ami-d15a75c7"
  instance_type = "t2.micro"
 # instance_type = "t2.nano"
  vpc_security_group_ids = ["${var.sg_nginx_id}", "${var.sg_ssh_id}", "${var.sg_consul_id}"]
  subnet_id = "${var.subnet_dmz_a}"
  associate_public_ip_address = true
  source_dest_check = false
  key_name = "${var.debug_key_pair_id}"
  user_data = "${data.template_file.open-vpn.rendered}"

  tags {
    Name = "open-vpn"
  }
}

data "template_file" "open-vpn" {
  template = "${file("${path.module}/files/open_vpn.sh")}"
}

resource "aws_eip_association" "eip_assoc_open_vpn" {
  instance_id = "${aws_instance.open_vpn.id}"
  allocation_id = "${var.eip_open_vpn_a_id}"
}

resource "aws_route53_record" "open_vpn_rt53" {
   zone_id = "${var.rt53_zone_id}"
   name = "open-vpn"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.open_vpn.private_ip}"]
}
