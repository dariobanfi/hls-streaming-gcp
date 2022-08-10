variable "region" {
  type = string
}

variable "zone" {
  type = string
}

variable "project_id" {
  type = string
}

provider "google" {
  region  = var.region
  zone    = var.zone
  project = var.project_id
}