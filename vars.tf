locals {
  pegged_azs = "${data.aws_availability_zones.available.names[0]},${data.aws_availability_zones.available.names[1]}"
}


variable "vpc_slash_16" {
  default = {
    "us-east-1"      = "110"
    "us-east-2"      = "110"
    "us-west-2"      = "120"
    "ap-southeast-1" = "130"
    "ap-southeast-2" = "140"
    "ap-northeast-1" = "150"
    "eu-central-1"   = "160"
    "eu-west-2"      = "170"
  }
}

variable "region" {
  default = "us-east-2"
}

variable "key_name" {
  default = "matthew.cadorette"
}

variable "amis" {
  default = {
    "master"  = "ami-9c0638f9"
    "linux"   = "ami-9c0638f9"
    "windows" = "ami-36241f53"
  }
}

variable "instance_type" {
  default = {
    "master"  = "m5.large"
    "cd4pe"   = "t2.medium"
    "windows" = "t2.medium"
    "linux"   = "t2.small"
  }
}

variable "windows_count" {
  default = "2"
}

variable "linux_count" {
  default = "3"
}
