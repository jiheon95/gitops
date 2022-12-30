
provider "aws" {
  region = "ap-northeast-2"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  skip_final_snapshot = true

  db_name             = var.db_name

  username = var.db_username
  password = var.db_password
}

# terraform {
#     backend "s3" { 
#       bucket         = "terraform-test-kjh-s3" # s3 bucket 이름
#       key            = "test/db/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
#       region         = "ap-northeast-2"  
#       encrypt        = true
#       dynamodb_table = "terraform_test-kjh-dynamodb" # 다이나모db 이름
#     }
# }
