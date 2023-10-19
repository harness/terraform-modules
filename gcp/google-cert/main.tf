resource "google_certificate_manager_dns_authorization" "default-auth" {
  project     = var.project
  name        = "${var.project}-default-dns-auth"
  domain      = var.domain
}

resource "google_dns_record_set" "default-dns-challenge" {
  project     = var.dns_zone_project
  name = google_certificate_manager_dns_authorization.default-auth.dns_resource_record[0].name
  type = "CNAME"
  ttl  = 300

  managed_zone = var.dns_zone

  rrdatas = [google_certificate_manager_dns_authorization.default-auth.dns_resource_record[0].data]
}

resource "google_certificate_manager_certificate" "default-cert" {
  project     = var.project
  name        = "${var.project}-default-cert"
  managed {
    domains = [
      "*.${var.domain}",
      var.domain
      ]
    dns_authorizations = [
      google_certificate_manager_dns_authorization.default-auth.id
      ]
  }
}

resource "google_certificate_manager_certificate_map" "default-cert-map" {
  project     = var.project
  name        = "${var.project}-default-cert-map"
  description = "default cert map for ${var.project}"
  labels = {
    "terraform" : true
  }
}

resource "google_certificate_manager_certificate_map_entry" "default-cert-map" {
  project     = var.project
  name        = "${var.project}-default-cert-map-entry"
  description = "default cert map entry for ${var.project}"
  map         = google_certificate_manager_certificate_map.default-cert-map.name
  labels = {
    "terraform" : true
  }

  certificates = [google_certificate_manager_certificate.default-cert.id]
  hostname = var.domain
}

resource "google_certificate_manager_certificate_map_entry" "default-cert-map-wildcard" {
  project     = var.project
  name        = "${var.project}-default-cert-map-entry-wildcard"
  description = "default wildcard cert map entry for ${var.project}"
  map         = google_certificate_manager_certificate_map.default-cert-map.name
  labels = {
    "terraform" : true
  }

  certificates = [google_certificate_manager_certificate.default-cert.id]
  hostname = "*.${var.domain}"
}
