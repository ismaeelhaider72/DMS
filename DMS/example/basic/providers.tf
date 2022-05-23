terraform {
  backend "local" {}
}

provider "aws" {
  default_tags {
    tags = {
      example = "DMS"
    }
  }
}
