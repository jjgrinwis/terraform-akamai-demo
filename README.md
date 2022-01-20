Akamai Terraform example to create an Akamai property with one or more hostnames and add it to an active security policy.
You can select our new Secure By Default(SBD) option to automatically create LetsEncrypt DV records, or use the enrollment-id of a pre-installed certificate.

In this example we're automatically adding the DV CNAME records to Akamai EdgeDNS. 
When the new property is activated on Akamai staging, it will being added to a security policy part of an active security configuration. 

As this is just for a demo we're not activating the new security configuration.
