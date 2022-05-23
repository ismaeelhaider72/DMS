terraform {
  backend "local" {}
}

provider "aws" {
  # region  = var.region_primary
  default_tags {
    tags = {
      example = "DMS"
    }
  }
}