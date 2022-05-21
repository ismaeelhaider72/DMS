terraform {
  backend "local" {}
}

provider "aws" {
  default_tags {
    tags = {
      example          = "DMS"
    }
  }
}

provider "aws" {
  # profile = var.profile
  region  = var.region-primary
  alias   = "region-primary"
}
