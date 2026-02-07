terraform {
  backend "s3" {
    endpoints = {
      s3       = "https://storage.yandexcloud.net"
      dynamodb = "https://docapi.serverless.yandexcloud.net/ru-central1/b1g3n95qr8v0au8r4uks/etnlrbao6186k2ri9mnm"

    }
    bucket = "default-bucket-name-eq44o4e3"
    region = "ru-central1"
    key    = "project/terraform.tfstate"

    dynamodb_table = "state-lock-table"

    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }
}