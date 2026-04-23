locals {
  max_pusher_name_len = 30 - length("pusher--${var.resource_suffix}")
  pusher_name         = "pusher-${substr(var.block_ref, 0, local.max_pusher_name_len)}-${var.resource_suffix}"
}

resource "google_service_account" "image_pusher" {
  account_id   = local.pusher_name
  display_name = "Image Pusher for ${var.app_name}"
}

resource "google_artifact_registry_repository_iam_member" "image_pusher_writer" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.writer"
  member     = "serviceAccount:${google_service_account.image_pusher.email}"
}

resource "google_artifact_registry_repository_iam_member" "image_pusher_reader" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.name
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.image_pusher.email}"
}

resource "google_service_account_iam_binding" "image_pusher_nullstone_agent" {
  service_account_id = google_service_account.image_pusher.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:${var.ns_agent_service_account_email}"]
}
