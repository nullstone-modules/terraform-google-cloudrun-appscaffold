resource "google_service_account" "app" {
  account_id   = local.resource_name
  display_name = "Service Account for Nullstone App ${var.app_name}"
}

# Allows the app SA to mint OAuth tokens for itself — needed, for example, to
# generate signed URLs for GCS bucket objects from within the workload.
resource "google_service_account_iam_member" "app_generate_token_self" {
  service_account_id = google_service_account.app.id
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = "serviceAccount:${google_service_account.app.email}"
}

resource "google_artifact_registry_repository_iam_member" "app_pull_image" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.app.email}"
}
