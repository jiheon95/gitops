
provider "aws" {
  region = "ap-northeast-2"
}

module "webserver_cluster" {
  source = "gitops/terraform/autoserver/module"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t3.large"
  min_size      = 2
  max_size      = 3
}

# terraform {
#     backend "s3" { 
#       bucket         = "terraform-test-kjh-s3" # s3 bucket 이름
#       key            = "test/autoscailing/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
#       region         = "ap-northeast-2"  
#       encrypt        = true
#       dynamodb_table = "terraform_test-kjh-dynamodb" # 다이나모db 이름
#     }
# }
