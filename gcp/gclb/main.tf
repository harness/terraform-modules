resource "google_compute_backend_service" "dummy" {
  project       = var.project
  name          = "${var.project}-dummy-backend-service"
  health_checks = [google_compute_health_check.dummy_healthcheck.id]
}

resource "google_compute_health_check" "dummy_healthcheck" {
  project             = var.project
  name                = "${var.project}-dummy-healthcheck"
  check_interval_sec  = 10
  unhealthy_threshold = 3
  healthy_threshold   = 2
  timeout_sec         = 5

  tcp_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

resource "google_compute_global_address" "default" {
  project    = var.project
  name       = "${var.project}-lb-ip"
}

resource "google_compute_global_forwarding_rule" "default-https" {
  project     = var.project
  name       = "${var.project}-default-frontend"
  target     = google_compute_target_https_proxy.default-https.id
  ip_address = google_compute_global_address.default.address
  port_range = "443-443"
}

resource "google_compute_target_https_proxy" "default-https" {
  project     = var.project
  name        = "${var.project}-default-target-proxy"
  url_map     = google_compute_url_map.default-lb.id
  certificate_map = "//certificatemanager.googleapis.com/${var.certmap_id}"
}

resource "google_compute_url_map" "default-lb" {
  project     = var.project
  name = "${var.project}-default-gclb"
  default_service = google_compute_backend_service.dummy.id

  dynamic host_rule {
    for_each = var.hostrule
    content {
      hosts = [host_rule.key]
      path_matcher = replace(host_rule.key, ".", "-")
    }
  }

  dynamic path_matcher {
    for_each = var.hostrule
    content {
      name = replace(path_matcher.key, ".", "-")
      default_service = path_matcher.value
    }
  }
}
