terraform {
  backend "s3" {
    bucket = "sddev-tf-state"
    key = "tfstate/terraform.tfstate"
    dynamodb_table = "sddev-tf-state-locking"
    region = "eu-west-2"
  }
}