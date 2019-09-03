
variable "network_cidr" {
}

variable "aws_region" {
}

variable "numberofbits" {
}

variable "aws_public_zones" {
  type = list(string)
}

variable "aws_private_zones" {
  type = list(string)
}

variable "Environment" {
  default = "raid-test"
}
variable ec2_instance {
  type = list(map(string))
}
# variable "ec2_public_instance" {
  # type = list(map(string))
# }
# variable "ec2_private_instance" {
  # type = list(map(string))
# }

variable "environment_name" {
}

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

