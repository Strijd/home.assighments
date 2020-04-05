network_cidr = "192.168.20.0/24"

aws_region = "us-east-1"

numberofbits = 2

environment_name = "raid-of-might"

aws_public_zones = ["us-east-1a", "us-east-1b"]

aws_private_zones = [ "us-east-1a","us-east-1b"]


Environment = "gods"

aws_access_key = ""

aws_secret_key = ""

ec2_instance = [
  {
    name       = "raid-test-1"
    private_ip = "192.168.20.10"
    az         = "us-east-1a"
    instance_type = "t2.medium"
    elastic_ip      = false
    type      = "public"
  }
]
