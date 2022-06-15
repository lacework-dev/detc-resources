variable "vpc_id" {}
variable "subnet1" {}
variable "subnet2" {}
variable "instance_name" {}
variable "instance_id" {}
variable "port" {
  default = "3000"
}
variable "cert_arn" {}

resource "aws_security_group" "ingress-alb-sg" {
  name   = "${var.instance_name}-ingress-alb-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = ["80", "443"]
    content {
      description = "open port ${ingress.value}"
      from_port   = tonumber(ingress.value)
      to_port     = tonumber(ingress.value)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_alb" "alb" {  
  name            = "${var.instance_name}-alb"
  subnets         = ["${var.subnet1}","${var.subnet2}"]
  security_groups = ["${aws_security_group.ingress-alb-sg.id}"]
  internal        = "false"  
  idle_timeout    = "5"
}

resource "aws_alb_listener" "alb_listener_http" {
  load_balancer_arn  = aws_alb.alb.arn
  port               = "80"
  protocol           = "HTTP"
  
  default_action {
    type = "redirect"

    redirect {
      port           = "443"
      protocol       = "HTTPS"
      status_code    = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "alb_listener_https" {
  load_balancer_arn  = aws_alb.alb.arn
  port               = "443"
  protocol           = "HTTPS"
  ssl_policy         = "ELBSecurityPolicy-2016-08"
  certificate_arn    = "${var.cert_arn}"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }
}

resource "aws_alb_listener_rule" "listener_rule" {
  depends_on         = ["aws_alb_target_group.alb_target_group"]
  listener_arn       = "${aws_alb_listener.alb_listener_https.arn}"
  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.alb_target_group.id}"
  }
  condition {
    path_pattern {
      values         = ["/*"]
    }
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name              = "${var.instance_name}-target-group"
  port              = "${var.port}"
  protocol          = "HTTP"
  vpc_id            = "${var.vpc_id}"

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = "true"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = "/"
    port                = "${var.port}"
  }
}

resource "aws_alb_target_group_attachment" "svc_physical_external" {
  target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
  target_id        = "${var.instance_id}"
  port             = "${var.port}"
}

output "alb_url" {
  value = aws_alb.alb.dns_name
}
