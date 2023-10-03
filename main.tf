provider "google" {
  credentials = file(var.service_account_path)
  project = var.project
  zone = var.zone
}

resource "random_string" "random_string" {
  length = 5
  special = false
  upper = false
  keepers = {}
}

resource "random_string" "random_sic_key" {
  length = 12
  special = false
}

resource "random_string" "generated_password" {
  length = 12
  special = false
}
