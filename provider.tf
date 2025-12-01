# create gcp provider
provider "google" {
  project = var.project_id
  region  = "asia-southeast1"
}