locals {
  first_filename = var.first_filename
}

variable "first_filename" {
  type = string
  default = "really_first.txt"
}

resource "local_file" "first" {
  filename =  local.first_filename
  content = "this is a file."
}

resource "local_file" "second" {
  filename = "second.txt"
  content = local_file.first.filename
}

resource "github_repository" "demo" {
  name        = "tf-demo-march-3-2023"
  description = "isn't this cool."

  visibility = "public"
}

resource "github_repository_file" "first" {
  repository = github_repository.demo.name
  file = local_file.first.filename
  content = local_file.first.content

  depends_on = [
    local_file.first
  ]
}

resource "github_repository_file" "first_txt" {
  repository = github_repository.demo.name
  file = "first.txt"
  content = data.github_repository_file.foo.content
}

data "github_repository_file" "foo" {
  repository          = github_repository.demo.name
  branch              = "main"
  file                = "really_first.txt"
}

resource "random_pet" "pets" {
  count = 2
}

resource "github_repository_file" "pets" {
  count = length(random_pet.pets)
  repository = github_repository.demo.name
  file = "pet${count.index + 1}.txt"
  content = random_pet.pets[count.index].id
}

resource "github_repository_file" "pets_map" {
  for_each = { for p in random_pet.pets : p.id => p.id }

  repository = github_repository.demo.name
  file = "${each.key}.txt"
  content = each.value
}

output "pet_name" {
  value = random_pet.pets[*].id
}

module "pet_names_count" {
  count = 4

  source = "./modules/pet_files"
  num_pets = count.index == 2 ? 6 : count.index
  github_repository_name = github_repository.demo.name
}

module "more_pet_names1" {
  source = "./modules/pet_files"
  num_pets = 2
  github_repository_name = github_repository.demo.name
}

output "more_pet_names1_files" {
  value = module.more_pet_names1.all_files
}

