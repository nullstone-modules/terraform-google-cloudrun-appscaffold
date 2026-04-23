locals {
  max_deployer_name_len = 30 - length("deployer--${var.resource_suffix}")
  deployer_name         = "deployer-${substr(var.block_ref, 0, local.max_deployer_name_len)}-${var.resource_suffix}"
}

resource "google_service_account" "deployer" {
  account_id   = local.deployer_name
  display_name = "Deployer for ${var.app_name}"
}

resource "google_project_iam_member" "deployer_update_access" {
  project = var.project_id
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_project_iam_member" "deployer_invoker_access" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_service_account_iam_member" "deployer_act_as_runtime" {
  service_account_id = google_service_account.app.id
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.deployer.email}"
}

resource "google_service_account_iam_binding" "deployer_impersonators" {
  service_account_id = google_service_account.deployer.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = [for email in var.op_impersonater_emails : "serviceAccount:${email}"]
}

resource "google_artifact_registry_repository_iam_member" "deployer_pull_image" {
  project    = google_artifact_registry_repository.this.project
  location   = google_artifact_registry_repository.this.location
  repository = google_artifact_registry_repository.this.repository_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.deployer.email}"
}
