locals {
  max_log_reader_name_len = 30 - length("log-reader--${var.resource_suffix}")
  log_reader_name         = "log-reader-${substr(var.block_ref, 0, local.max_log_reader_name_len)}-${var.resource_suffix}"
}

resource "google_service_account" "log_reader" {
  account_id   = local.log_reader_name
  display_name = "Log Reader for ${var.app_name}"
}

resource "google_project_iam_member" "log_reader_logs_access" {
  project = var.project_id
  role    = "roles/logging.viewer"
  member  = "serviceAccount:${google_service_account.log_reader.email}"
}

resource "google_service_account_iam_binding" "log_reader_nullstone_agent" {
  service_account_id = google_service_account.log_reader.id
  role               = "roles/iam.serviceAccountTokenCreator"
  members            = ["serviceAccount:${var.ns_agent_service_account_email}"]
}
