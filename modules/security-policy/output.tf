output "policy_id" {
  value = data.akamai_appsec_security_policy.specific_security_policy
}

output "security_config" {
  value = data.akamai_appsec_configuration.security_configuration
}
