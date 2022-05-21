terraform {
  backend "local" {}
}

provider "aws" {
  region  = var.region-primary
  default_tags {
    tags = {
      example          = "DMS"
    }
  }
}
