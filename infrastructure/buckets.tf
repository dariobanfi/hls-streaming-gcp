resource "google_storage_bucket" "raw_files" {
    name          = "hls-streaming-gcp-raw-files-${var.project_id}"
    location      = var.region
    force_destroy = true  
    uniform_bucket_level_access = true
}


resource "google_storage_bucket" "processed_files" {
    name          = "hls-streaming-gcp-processed-files-${var.project_id}"
    location      = var.region
    force_destroy = true
    uniform_bucket_level_access = true
}

resource "google_storage_bucket_iam_member" "public" {
  bucket = google_storage_bucket.processed_files.name
  role = "roles/storage.objectViewer"
  member = "allUsers"
}