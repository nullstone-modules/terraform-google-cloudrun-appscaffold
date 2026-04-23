output "repository_id" {
  value       = google_artifact_registry_repository.this.repository_id
  description = "The repository ID of the artifact registry repository."
}

output "repository_name" {
  value       = google_artifact_registry_repository.this.name
  description = "The fully-qualified resource name of the artifact registry repository."
}

output "repository_url" {
  value       = local.repository_url
  description = "The image URL (without tag) for pushing container images to this app's repository."
}

output "app_service_account" {
  value = {
    id    = google_service_account.app.id
    name  = google_service_account.app.name
    email = google_service_account.app.email
  }
  description = "The app runtime service account. The workload should run as this SA, and capability-layer bindings (e.g. secretmanager.secretAccessor) should target its email."
}

output "image_pusher" {
  value = {
    project_id  = var.project_id
    email       = google_service_account.image_pusher.email
    id          = google_service_account.image_pusher.id
    impersonate = true
  }
  description = "Service account with artifactregistry.writer/reader on the repo. Impersonatable by the Nullstone agent."
}

output "deployer" {
  value = {
    project_id  = var.project_id
    email       = google_service_account.deployer.email
    id          = google_service_account.deployer.id
    impersonate = true
  }
  description = "Service account with run.developer, run.invoker, and serviceAccountUser on the app runtime SA. Impersonatable by the Nullstone agent."
}

output "log_reader" {
  value = {
    project_id  = var.project_id
    email       = google_service_account.log_reader.email
    id          = google_service_account.log_reader.id
    impersonate = true
  }
  description = "Service account with logging.viewer. Impersonatable by the Nullstone agent."
}

output "metrics_reader" {
  value = {
    project_id  = var.project_id
    email       = google_service_account.deployer.email
    impersonate = true
  }
  description = "Service account with monitoring.viewer. Aliased to the deployer SA; callers provide their own PromQL metric mappings."
}
