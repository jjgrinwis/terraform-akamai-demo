output "secure_by_default" {
  # only need to return dv string if we have a secure by default setup
  description = "Return list of CNAME records that needs to be created to active the secur by default DV certs"
  value       = var.cert_provisioning_type == "DEFAULT" ? module.property.dv_keys : null
}

output "rules" {
  description = "Are these rules updated from the template or Akamai Control Center (ACC)"
  value       = module.property.rules
}

/* output "security_config" {
  description = "Information about our updated security configuration"
  value       = module.security_policy
} */

output "aka_staging" {
  value = resource.akamai_property_activation.aka_staging
}
