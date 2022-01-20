output "rules" {
  value = local.acc_managed ? "Rules provided by Akamai Control Center (ACC)" : "Rules created from template"
}

output "dv_keys" {
  # return an empty list as our edgedns_dv module will check the length if it needs to create it
  # we can't use null as our length() check will fail
  value = var.cert_provisioning_type == "DEFAULT" ? resource.akamai_property.aka_property.hostnames[*].cert_status[0] : []
}

output "id" {
  value = resource.akamai_property.aka_property.id
}

output "version" {
  value = resource.akamai_property.aka_property.latest_version
}
