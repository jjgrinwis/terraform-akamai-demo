# our dynamic input vars with default values
variable "acc_managed" {
  description = "Are rules managed from Akamai Control Center (ACC)?"
  type        = bool
  default     = true
}

# let's use two default values as these will be the same most of the time.
variable "product_name" {
  # will be mapped to variable aka_products
  description = "The 'known' Akamai delivery product name like dsa or ion"
  type        = string
  default     = "ion"
}

# IPV4, IPV6_PERFORMANCE or IPV6_COMPLIANCE 
variable "ip_behavior" {
  description = "IPv4 and IPv6 by default, if only you want to use IPv4 choose IPV4"
  type        = string
  default     = "IPV6_COMPLIANCE"
}

variable "enrollment_id" {
  description = "The enrollment id of the certificate: 'akamai cps list'"
  type        = number
  default     = null
}

# cert type can be DEFAULT or CPS_MANAGED
# we added some validation rule just as an example
variable "cert_provisioning_type" {
  description = "CPS_MANAGED or Secure by Default (DEFAULT)"
  type        = string
  default     = "DEFAULT"
  validation {
    condition     = can(regex("CPS_MANAGED|DEFAULT", var.cert_provisioning_type))
    error_message = "The cert_provisioning type should be CPS_MANAGED or DEFAULT."
  }
}

variable "domain_suffix" {
  description = "Edgehostname suffix: [edgesuite|edgekey].net"
  type        = string
  default     = "edgesuite.net"
  validation {
    condition     = can(regex("edgesuite.net|edgekey.net|akamaized.net", var.domain_suffix))
    error_message = "The domain_suffix should be one of [edgesuite,edgekey,akamaied].net."
  }
}

variable "origin" {
  description = "The origin hostname"
  type        = string
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

# create a new cpcode or look this one oup
variable "cpcode" {
  description = "The Content Provider admin code"
  type        = string
}

variable "group_name" {
  description = "Akamai group to create this resource in"
  type        = string
}

variable "email" {
  description = "Email address of users to inform when property gets created"
  type        = string
}


