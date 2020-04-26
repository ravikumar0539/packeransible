variable "domain" {
}
variable "env" {
}
variable "vpc" {
}
variable "countin" {
}

variable "region" {
}


provider "aws" {
    access_key = ""
    secret_key = ""
    region = "${var.region}"
}

module "myvpc" {
  source = "../modules/vpc"
  vpc_cidr= "${var.vpc}"
  environment="${var.env}"
  counting="${var.countin}"
  
}
module "loadbalancer" {
  source = "../modules/lb"
  environment="${var.env}"
  subnets= "${module.myvpc.publicsubnets}"
  security = ["${module.myvpc.security}"]
   vpcid= "${module.myvpc.vpc_id}"
 
  
}
module "dnsroute53" {
  source = "../modules/dns"
  domainname="${var.domain}"
  environment="${var.env}"
  vpcid= "${module.myvpc.vpc_id}"
  elbdnsname = "${module.loadbalancer.elbdns}"
  elbzone = "${module.loadbalancer.elbzone}"
  albdnsname = "${module.loadbalancer.albdns}"
  albzone = "${module.loadbalancer.albzone}"
  
}

resource "local_file" "foo" {
    content  = "security_groups: ${module.myvpc.security}\nelb: ${module.loadbalancer.elbname}\nalbname: ${module.loadbalancer.albname}\nregion: ${var.region}"
    filename = "${path.module}/packer/group_vars/all"
}
