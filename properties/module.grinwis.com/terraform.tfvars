# list of hostnames to create
hostnames = ["module.grinwis.com", "www.module.grinwis.com", "test.module.grinwis.com"]

# origin hostname
origin = "netlify.grinwis.com"

# cpcode to use in your configuration, create or lookup
# if using existing cpcode it should match product_id
cpcode = "demo.grinwis.com"

# group to create resources in
group_name = "Ion Standard Beta Jam 1-3-16TWBVX"

# what user to inform when hostname has been created
email = "nobody@akamai.com"

# secuirty related information
# our security configuration
security_configuration = "WAF Security File"

# security policy to attach this property to. Security policy should be part of security config var.security_configuration
security_policy = "Monitoring Only Security Policy"
#security_policy = "api_protection"
