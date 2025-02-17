provider "aws" {
  region = var.region
}

provider "aws" {
  alias  = "west"
  region = var.dr_parameters["dr_region"]
}
