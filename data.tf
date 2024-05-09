data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "saurabh-bucket-tf"
    key    = "dev/tf-vpc/teraform.tfstate"
    region = "us-east-1"
  }
}

data "aws_ami" "custom_ami" {
  most_recent      = true
  name_regex       = "Ansible-AMI"
  owners           = ["058264375008"]
}
