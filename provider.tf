# terraform {
#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "3.9.0"    # AWS provider version, not terraform version 
#     }
#   }

#   backend "s3" {
# 				bucket = "daws76s-remote-state06"
# 				key    = "vpc_test"
# 				region = "us-east-1"
# 				dynamodb_table = "daws76s-locking"
# 				}
# }

# provider "aws" {
#  region  ="us-east-1"
# }