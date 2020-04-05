network_cidr = "10.100.1.0/24"

aws_region = "eu-west-1"

numberofbits = 2

environment_name = "raid"

aws_public_zones = ["eu-west-1a", "eu-west-1b"]

aws_private_zones = [ "eu-west-1a","eu-west-1b"]


Environment = "gods"

aws_access_key = ""

aws_secret_key = ""

ec2_instance = [
  {
    name       = "vpn-server"
    private_ip = "10.100.1.10"
    az         = "eu-west-1a"
    instance_type = "t2.medium"
    public_ip      = true
    ami       = "ami-0f630a3f40b1eb0b8"
    type      = "public"
  },
  {
    name       = "web-server"
    private_ip = "10.100.1.133"
    az         = "eu-west-1a"
    instance_type = "t2.xlarge"
    public_ip      = false
    ami       = "ami-0f630a3f40b1eb0b8"
    type      = "private"

  }

]
