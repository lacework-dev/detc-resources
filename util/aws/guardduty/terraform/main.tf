variable "bucket" {}
variable "malicious_ip" {}
variable "region" {}

provider "aws" {
  region = var.region
}

resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
}

resource "aws_s3_object" "attacker-threat-list" {
  content = var.malicious_ip
  bucket  = var.bucket
  key     = "attacker-threat-list"
}

resource "aws_guardduty_threatintelset" "attacker-threat-list" {
  activate    = true
  detector_id = aws_guardduty_detector.main.id
  format      = "TXT"
  location    = "https://s3.amazonaws.com/${aws_s3_object.attacker-threat-list.bucket}/${aws_s3_object.attacker-threat-list.key}"
  name        = "AttackerThreatList"
}
