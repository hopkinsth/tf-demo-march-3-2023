locals {
  first_filename = var.first_filename
}

variable "first_filename" {
  type = string
  default = "first.txt"
}

resource "local_file" "first" {
  filename =  local.first_filename
  content = "this is a file."
}

resource "local_file" "second" {
  filename = "first_id.txt"
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
}