terraform {
  backend "remote" {
    hostname = "statefarm.scalr.io"
    workspaces {
      prefix = "sf-"
    }
  }
}
