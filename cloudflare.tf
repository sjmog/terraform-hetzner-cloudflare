resource "cloudflare_record" "subdomain" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  name    = var.subdomain
  content = var.web_servers_count > 1 ? hcloud_load_balancer.web_load_balancer[0].ipv4 : hcloud_server.web[0].ipv4_address
  type    = "A"
  proxied = true
}

resource "cloudflare_page_rule" "https" {
  zone_id = data.cloudflare_zones.domain.zones[0].id
  target  = var.subdomain == "@" ? "${var.domain_name}/*" : "${var.subdomain}.${var.domain_name}/*"
  actions {
    always_use_https = true
  }
}
