variable "vpc_id" {}
variable "agent_sg_id" {}
variable "server_sg_id" {}

resource "aws_security_group_rule" "jenkins-server-web-traffic" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = var.server_sg_id
}

resource "aws_security_group_rule" "jenkins-server-agent-traffic" {
  type                     = "ingress"
  from_port                = 5000
  to_port                  = 5000
  protocol                 = "tcp"
  security_group_id        = var.server_sg_id
  source_security_group_id = var.agent_sg_id
}
