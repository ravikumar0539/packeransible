variable "vpcid" {
}
variable "elbdnsname" {
}
variable "elbzone" {
}
variable "albdnsname" {
}
variable "albzone" {
}
variable "environment" {
  
}

variable "domainname" {
  
}




resource "aws_route53_zone" "internal" {
  name = "${var.domainname}"
  vpc {
    vpc_id = "${var.vpcid}"
  }
}
resource "aws_route53_record" "service"{
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "serviceelb-${var.environment}"
    type = "CNAME"
    alias {
    name                   = "${var.elbdnsname}"
    zone_id                = "${var.elbzone}"
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "servicealb"{
    zone_id = "${aws_route53_zone.internal.zone_id}"
    name = "servicealb-${var.environment}"
    type = "CNAME"
    alias {
    name                   = "${var.albdnsname}"
    zone_id                = "${var.albzone}"
    evaluate_target_health = true
  }
}