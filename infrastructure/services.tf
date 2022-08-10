resource "google_project_service" "compute_service" {
    service = "compute.googleapis.com"
}

resource "google_project_service" "transcoder_service" {
    service = "transcoder.googleapis.com"
}

resource "google_project_service" "cloudfunctions_service" {
    service = "cloudfunctions.googleapis.com"
}

resource "google_project_service" "cloudbuild_service" {
    service = "cloudbuild.googleapis.com"
}


resource "google_project_service" "pubsub_service" {
    service = "pubsub.googleapis.com"
}

resource "google_project_service" "logging_service" {
    service = "logging.googleapis.com"
}

resource "google_project_service" "eventarc_service" {
    service = "eventarc.googleapis.com"
}

resource "google_project_service" "artifactregistry_service" {
    service = "artifactregistry.googleapis.com"
}

resource "google_project_service" "run_service" {
    service = "run.googleapis.com"
}