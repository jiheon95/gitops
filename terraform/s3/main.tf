provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = "terraform-test-kjh-s3"
 # 실수로 s3 삭제하는것을 방지
  lifecycle {
    prevent_destroy = true
  }

}

# 버전 관리
resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 암호화
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 퍼블릭 차단
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform_test-kjh-dynamodb"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
###### 주석 후 init 한번 하고 추가
# terraform {
#     backend "s3" { 
#       bucket         = "terraform-test-kjh-s3" # s3 bucket 이름
#       key            = "test/s3/terraform.tfstate" # s3 내에서 저장되는 경로를 의미합니다.
#       region         = "ap-northeast-2"  
#       encrypt        = true
#       dynamodb_table = "terraform_test-kjh-dynamodb" # 다이나모db 이름
#     }
# }
