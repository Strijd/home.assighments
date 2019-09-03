variable "env_name" {}
variable "vpc_security_group_ids" {type = list(string)}
variable "ec2_group"  { type = list(map(string))}
variable "vpc_public_subnet_id" {type = map}
variable "vpc_private_subnet_id" {type = map}
variable "associate_public_ip_address"  {
  type = bool
  default = false
}



resource "aws_instance" "this_instance" {
  count         = length(var.ec2_group)
  ami           = "ami-07d0cf3af28718ef8"
  instance_type = var.ec2_group[count.index]["instance_type"]
  vpc_security_group_ids      = var.vpc_security_group_ids
  subnet_id                   = var.ec2_group[count.index]["type"] == "public" ? var.vpc_public_subnet_id[var.ec2_group[count.index]["az"]] : var.vpc_private_subnet_id[var.ec2_group[count.index]["az"]]
  associate_public_ip_address = var.associate_public_ip_address ? true : false
  source_dest_check           = true
  private_ip                  = var.ec2_group[count.index]["private_ip"]
  key_name                    = "raid"
  tags = merge(
    {
      "Name" = format("%v-%v", var.env_name,var.ec2_group[count.index]["name"])
    },
  )
}
