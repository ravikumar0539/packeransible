resource "aws_alb" "main" {
  name            = "applicationloadbalancer-${var.environment}"
  subnets         = "${var.subnets}"
  security_groups = "${var.security}"
}
resource "aws_alb_target_group" "mainapp" {
  name       =  "applicationtargetgroup-${var.environment}"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = "${var.vpcid}"
  target_type = "instance"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    unhealthy_threshold = "2"
  }
}

# Redirect all traffic from the ALB to the target group

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.main.id}"
  port              = "${var.apport}"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.mainapp.id}"
    type             = "forward"
  }
}
#resource "aws_alb_listener" "ssl_end" {
 # load_balancer_arn = "${aws_alb.main.id}"
  #port              = "${var.outport}"
  #protocol          = "HTTPS"

  #default_action {
   # target_group_arn = "${aws_alb_target_group.mainapp.id}"
   # type             = "forward"
  #}
#}

resource "aws_elb" "elbtest" {
  name = "classicloadbalaner-${var.environment}"
  subnets = "${var.subnets}"
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
 # listener {
  #  instance_port      = 80
   # instance_protocol  = "http"
    #lb_port            = 443
    #lb_protocol        = "https"

  #}
  security_groups = "${var.security}"
   health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

resource "aws_iam_role" "s3_role" {
  name = "s3_role"

  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  }
  EOF
}
resource "aws_iam_role_policy" "s3_policy" {
  name = "s3_policy"
  role = "${aws_iam_role.s3_role.id}"

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
         "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "arn:aws:s3:::testingassignment/*"
      }
    ]
  }
  EOF
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "s3readrole"
  role = "${aws_iam_role.s3_role.name}"
}
output "elbdns"{
    value = "${aws_elb.elbtest.dns_name}"
}
output "elbname"{
    value = "${aws_elb.elbtest.name}"
}
output "elbzone"{
    value = "${aws_elb.elbtest.zone_id}"
}

output "albdns"{
    value = "${aws_alb.main.dns_name}"
}
output "albname"{
    value = "${aws_alb.main.name}"
}
output "albzone"{
    value = "${aws_alb.main.zone_id}"
}