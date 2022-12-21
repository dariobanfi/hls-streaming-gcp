resource "google_project_service" "compute_service" {
    project = var.project_id
    service = "compute.googleapis.com"
}

resource "google_project_service" "transcoder_service" {
    project = var.project_id
    service = "transcoder.googleapis.com"
}
