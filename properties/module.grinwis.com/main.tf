# our modules based example.
# let's keep the terraform config to a minimum
terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "1.9.1"
    }
  }
}

# for cloud usage these vars have been defined in terraform cloud as a set
# Configure the Akamai Provider to use betajam credentials
provider "akamai" {
  edgerc         = "~/.edgerc"
  config_section = "betajam"
}

# now create our property using our module with input vars
# this module will only create the property but won't active it.
module "property" {
  source = "../../modules/property"

  # if managed from ACC the only initial version will be created from template
  # you can use a tfvars variable or use '-var="acc_managed=false"' to overwrite
  acc_managed = var.acc_managed

  hostnames     = distinct(var.hostnames)
  origin        = var.origin
  cpcode        = var.cpcode
  group_name    = var.group_name
  domain_suffix = var.domain_suffix
}

locals {
  # covert the list of maps to a map of maps with entry.hostname as key of the map
  # keys in the map are the same as entries in var.hostnames[] 
  dv_records = { for entry in module.property.dv_keys : entry.hostname => entry }
}

# if you your DNS provider has a Terraform module just use it here to create the CNAME records
# let's create our DV records using a module with with different credentials
# providers cannot be configured within modules using count, for_each or depends_on
# as we have separate credentials/provider config for EdgeDNS, do the for_each check in the edgens_cname module
module "edgedns_cname" {
  source = "../../modules/edgedns_cname"

  # for_each needs a known lists, it can't use a dynamic list/amo that's still to be defined. 
  # so we're feeding a fixed lists with our hostnames and going to use that a key into our dv_records map
  hostnames  = distinct(var.hostnames)
  dv_records = local.dv_records
}

# now let's activate the latest version of our created property which is default for staging platform
resource "akamai_property_activation" "aka_staging" {
  property_id = module.property.id
  contact     = [var.email]
  version     = module.property.version
  network     = "STAGING"
  note        = "Action triggered by Terraform."
}

resource "time_sleep" "security_selected_hostnames_propagation" {
  # it takes some time until new hostname is visable in the security configuration
  # so let's wait a couple of seconds after the aka_staging has been created
  create_duration = "10s"

  # creating a trigger on something we only know after the apply
  # we need to feed this depency graph into our security module as it will try to add hostname will not active
  triggers = {
    aka_staging = resource.akamai_property_activation.aka_staging.version
  }
}

module "security_policy" {
  source = "../../modules/security-policy"

  # our active security configuration
  security_configuration = var.security_configuration

  # the security policy in our security configuration
  security_policy = var.security_policy

  # hostnames to add to our security configuration
  hostnames = var.hostnames

  # our dummy var to create a dependency graph with the activation of a property
  # we can't use a depends_on[] due to separate provider auth. config. in this policy
  # a graph alone is not enought, we also need to wait a couple fo secs.
  dummy = resource.time_sleep.security_selected_hostnames_propagation.triggers["aka_staging"]
}
