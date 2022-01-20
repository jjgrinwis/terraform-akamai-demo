variable "security_configuration" {
  description = "Akamai Security configuration with the active Security Policy where we're going to add hostnames[] to"
  type        = string
  validation {
    condition     = length(var.security_configuration) > 0
    error_message = "Please provide a valid name for the Security Configuration."
  }
}


variable "security_policy" {
  description = "The security policy to add this hostname to"
  type        = string
  validation {
    condition     = length(var.security_policy) > 0
    error_message = "Please provide a valid name for the Security Policy that's part of your Security Configuration."
  }
}

variable "hostnames" {
  # first entry in list will also be property name
  # entry 0 will also be used to create edgehostname, every element in list shouls be unique
  description = "One or more hostnames for a single property"
  type        = list(string)
  validation {
    condition     = length(var.hostnames) > 0
    error_message = "At least one hostname should be provided, it can't be empty."
  }
}

variable "dummy" {
  type = string
}
