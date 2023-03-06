terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "~> 2.3.0"
    }
    github = {
      source = "integrations/github"
      version = "~> 5.18.0"
    }
  }
}

provider "local" {}

provider "github" {
  token = replace(sensitive(file("./gh-token")), "\n", "")
  owner = "hopkinsth"
}

