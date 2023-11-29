provider "aws" {
    region                   = "ap-south-2"
    shared_config_files      = ["C:\\Users\\SrijaPothamshetti\\.aws\\config"]  
    shared_credentials_files = ["C:\\Users\\SrijaPothamshetti\\.aws\\credentials"]  
 }

resource "aws_s3_bucket" "name" {
    bucket = var.s3-bucket-name
}
