# our dynamic input vars with default values
# without any default value Terraform will ask for a vaule or use it from tfvars file

# where are you going to manage your rules from, ACC or local template dir
variable "acc_managed" {
  description = "Are you managing your rules from Akamai Control Center (ACC)?"
  type        = bool
  default     = true
}

# akamai product to use
variable "product_name" {
  description = "The Akamai delivery product name"
  type        = string
  default     = "ion"
}

# map of akamai products, just to make life easy
variable "aka_products" {
  description = "map of akamai products"
  type        = map(string)

  default = {
    "ion" = "prd_Fresca"
    "dsa" = "prd_Site_Accel"
    "dd"  = "prd_Download_Delivery"
  }
}

# IPV4, IPV6_PERFORMANCE or IPV6_COMPLIANCE 
variable "ip_behavior" {
  description = "use IPV4 to only use IPv4"
  type        = string
  default     = "IPV6_COMPLIANCE"
}

variable "enrollment_id" {
  description = "The enrollment id of the certificate 'akamai cps list"
  type        = number
  default     = null
}

# cert type can be DEFAULT or CPS_MANAGED
variable "cert_provisioning_type" {
  description = "CPS_MANAGED or Secure by Default"
  type        = string
  default     = "DEFAULT"
}

variable "domain_suffix" {
  description = "edgehostname suffix"
  type        = string
  default     = "edgesuite.net"
}

variable "origin" {
  description = "The origin hostname"
  type        = string
}

variable "hostnames" {
  # first entry in list will also be property name
  # entry 0 will also be used to create edgehostname and will be name of property
  description = "One or more hostnames for a single property"
  type        = list(string)
}

# create a new cpcode or look this one oup
variable "cpcode" {
  description = "The Content Provider code"
  type        = string
}

variable "group_name" {
  description = "Akamai group to use this resource in"
  type        = string
}
