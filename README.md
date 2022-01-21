# Akamai Terraform #

An example on how to create an Akamai property with one or more hostnames and add it to an active security policy.
You can select our new Secure By Default(SBD) option to automatically create LetsEncrypt DV records, or use the enrollment-id of a pre-installed certificate requested via CPS.

You can manage your rules via Akamai Control Center (ACC) or from the template directory. The initial version will always be deployed from the template directory using some pre-defind vars. Hostnames can just be added or removed from to the var.hostnames[] list and Terraform will do the heavy lifting of removing/adding hostnames.

In this example we're automatically adding the DV CNAME records to Akamai EdgeDNS but you add them manually or use other Terraform Provider.
When the new property is activated on Akamai staging it will being added to a security policy part of an active security configuration.

Below a visual of the plan that's going to be implemented: 
![image](https://user-images.githubusercontent.com/3455889/150530341-cb537a21-c45e-48bf-823f-b1429bd70f68.png)
created via: https://hieven.github.io/terraform-visual/

_As this is just for a demo we're not activating the new security configuration!_
