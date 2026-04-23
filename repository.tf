locals {
  resource_name = "${var.block_ref}-${var.resource_suffix}"
}

resource "google_artifact_registry_repository" "this" {
  location      = var.region
  repository_id = local.resource_name
  format        = "DOCKER"
  docker_config {
    immutable_tags = true
  }
  labels = var.repo_labels
}

locals {
  repository_url = "${google_artifact_registry_repository.this.location}-docker.pkg.dev/${google_artifact_registry_repository.this.project}/${google_artifact_registry_repository.this.name}/${var.app_name}"
}
