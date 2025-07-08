terraform {
  backend "s3" {
    bucket         = "myterraform-dr-bucket"
    key            = "warm-standby/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}