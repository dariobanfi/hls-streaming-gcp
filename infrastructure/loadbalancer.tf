resource "google_compute_global_address" "load-balancer-ip" {
  name         = "load-balancer-ip"
  address_type = "EXTERNAL"
  ip_version   = "IPV4"
}

resource "google_compute_backend_bucket" "hls-streaming-bucket" {
  name        = "hls-streaming-bucket"
  bucket_name = google_storage_bucket.processed_files.name
  enable_cdn  = true
  cdn_policy {
    cache_mode = "CACHE_ALL_STATIC"
    default_ttl = 2419200
    max_ttl = 2419200
  }
}

resource "google_compute_url_map" "hls-streaming-load-balancer" {
    name = "hls-streaming-load-balancer"
    default_service = google_compute_backend_bucket.hls-streaming-bucket.id
}

resource "google_compute_target_http_proxy" "hls-streaming-load-balancer-proxy" {
    name = "hls-streaming-load-balancer-proxy"
    url_map = google_compute_url_map.hls-streaming-load-balancer.id
}

resource "google_compute_global_forwarding_rule" "hls-streaming-load-balancer-forwarding-rule" {
    name = "hls-streaming-load-balancer-forwarding-rule"
    load_balancing_scheme = "EXTERNAL_MANAGED"
    ip_address = google_compute_global_address.load-balancer-ip.id
    target = google_compute_target_http_proxy.hls-streaming-load-balancer-proxy.id
    port_range = 80
}
