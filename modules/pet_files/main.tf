variable "num_pets" {
  type = number
  default = 2
}

resource "random_id" "module" {
  byte_length = 1
}

variable "github_repository_name" {
  type = string
}

resource "random_pet" "pets" {
  count = var.num_pets
}

resource "github_repository_file" "pets" {
  count = length(random_pet.pets)
  repository = var.github_repository_name
  file = "${random_id.module.id}_pet${count.index + 1}.txt"
  content = random_pet.pets[count.index].id
}

output "all_files" {
  value = github_repository_file.pets[*].file
}

terraform {
  required_providers {
    github = {
      source = "integrations/github"
      version = "~> 5.18.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}