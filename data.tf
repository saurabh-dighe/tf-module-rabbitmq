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
  name_regex       = "Base-AMI-Ansible"
  owners           = ["992382386864"]
}

data "aws_secretsmanager_secret" "roboshop_secrets" {
  name      = "roboshop_secrets"            
}

#Extracting the sectrets
data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.roboshop_secrets.id
}