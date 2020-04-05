provider "aws" {
  shared_credentials_file = "~/.viz/creds"
  profile                 = "default"
  region                  = var.aws_region
}
