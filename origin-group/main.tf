resource "azurerm_cdn_frontdoor_origin_group" "origin-group" {
  name                     = "${var.origin_group_name}-origin-group"
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  health_probe {
    interval_in_seconds = 100
    path                = "/"
    protocol            = "Http"
    request_type        = "HEAD"
  }
  load_balancing {}
}

resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = "${var.origin_group_name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group.id
  enabled                       = true
  certificate_name_check_enabled = true
  host_name          = var.host_name
  http_port          = 80
  https_port         = 443
  origin_host_header = var.host_name
  priority           = 1
  weight             = 1
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "${var.origin_group_name}-endpoint"
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
  enabled                  = true
  tags = var.tags
}


resource "azurerm_cdn_frontdoor_rule_set" "rule-set" {
  name                     = replace("${var.origin_group_name}-rule-set","-","")
  cdn_frontdoor_profile_id = var.cdn_frontdoor_profile_id
}


resource "azurerm_cdn_frontdoor_route" "routing" {
  name                          = replace("${var.origin_group_name}-route","-","")
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin-group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.origin.id]
  cdn_frontdoor_rule_set_ids    = [azurerm_cdn_frontdoor_rule_set.rule-set.id]
  enabled                       = true

  forwarding_protocol    = "HttpsOnly"
  https_redirect_enabled = true
  patterns_to_match      = [var.path]
  supported_protocols    = ["Http", "Https"]

  cdn_frontdoor_custom_domain_ids = []
  link_to_default_domain          = true
}