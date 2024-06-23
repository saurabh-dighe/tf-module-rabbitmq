# Provisions a spot instance for rabbitmq
resource "aws_spot_instance_request" "rabbitmq" {
  ami                     = data.aws_ami.custom_ami.id
  instance_type           = var.RABIIT_MQ_INSTANCE_TYPE
  subnet_id               = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID[0]
  vpc_security_group_ids  = [aws_security_group.allow_rabbitmq.id]
  wait_for_fulfillment    = true

  tags = {
    Name = "roboshop-${var.ENV}-rabbitmq-spot-request"
  }
}

resource "aws_ec2_tag" "web_server" {
  # ... other instance configuration options
  resource_id  = aws_spot_instance_request.rabbitmq.spot_instance_id
  key         = "Name"
  value       = "roboshop-${var.ENV}-rabbitmq"
}

resource "null_resource" "remote_provisioner" {
  # Establishes connection to be used by all
  connection {
    type     = "ssh"
    user     = local.SSH_USERNAME
    password = local.SSH_PASSWORD
    host     = aws_spot_instance_request.rabbitmq.private_ip
  }

  provisioner "remote-exec" {
    inline = [
      "ansible-pull -U https://github.com/saurabh-dighe/Ansible.git -e ENV=dev -e COMPONENT=rabbitmq roboshop-pull.yml"
    ]
  }
}



# resource "aws_db_instance" "mysql" {
#   allocated_storage       = 10
#   identifier              = "roboshop-${var.ENV}-mysql"
#   engine                  = "mysql"
#   engine_version          = "5.7"
#   instance_class          = "db.t3.micro"
#   username                = "admin1"
#   password                = "RoboShop1"
#   parameter_group_name    = "mysql.mysql5.7"
#   skip_final_snapshot     = true
#   db_subnet_group_name    = aws_db_subnet_group.mysql.name
#   vpc_security_group_ids  = [aws_security_group.allow_mysql.id]
# }

# #Provisions parameter group for RDS
# resource "aws_db_parameter_group" "mysql" {
#   name   = "rds-pg"
#   family = "mysql5.7"
# }

# #Provisions security group
# resource "aws_db_subnet_group" "mysql" {
#   name       = "roboshop-${var.ENV}-mysql"
#   subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_ID 

#   tags = {
#     Name = "roboshop-${var.ENV}-subent-grp"
#   }
# }
