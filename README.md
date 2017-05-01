# ARM-FunctionApp-in-ILBASE-SelfSignedCert
ARM templates that creates a Function App in an ILB ASE with self-signed certificate. These templates are based on [Create App Service Environment with an ILB Address, by Stefan Schackow](https://azure.microsoft.com/en-us/resources/templates/201-web-app-ase-ilb-create/). 

What I try to achieve: get a Function App working in an ILB ASE - including the Functions Portal experience

STATUS: work in progress, when opening the Function App still errors appear that the portal is not able to access the keys

# current problem
When opening the Function App in the Portal still this error is logged:
GET https://functionappname.scm.your-dns.suffix/api/vfs/site/wwwroot/proxies.json 404 (Not Found)

# Problems solved so far

## Creating the self-signed certificate
Script ```createCertificate.PS1``` can be used to create the certificate.

Replace/set these placeholders:
- ```{dnsSuffix}``` with your custom domain / DNS suffix (further on in this document stated as *your-dns.suffix*)
- ```{pfxPassword}``` 
- ```{pfxLocalFilename}``` 

After executiion of the script transfer the *Thumbprint* and *b64* outputs into the parameters required by the main ARM template ```azuredeploy.json```.

## Function App does not open correctly in Portal

### name resolution
The Portals JavaScript / the browser needs to find the Function App host. 
One of the errors logged in browser console: *Failed to load resource: net::ERR_NAME_NOT_RESOLVED*

I added the Function Apps IP address [1] to the local hosts file [2].

1. determine Function App IP address from : Platform features > All App Settings > Custom domains > IP address
2. local hosts. file : ```%windir%\System32\drivers\etc\hosts.```
(needs to be opened with an editor in elevated mode)
add 1 line for *functionappname.your-dns.suffix* and 1 line for *functionappname.scm.your-dns.suffix*

###  / certificate errors
Problem with a self-signed certificate is that there is no chaining to a root CA hence access to a resource with such a certificate is assumed insecure.
One of the errors logged in browser console: *OPTIONS https://functionappname.scm.your-dns.suffix/api/functions net::ERR_INSECURE_RESPONSE*

I imported the PFX file into the local machine "Trusted Root Certification Authorities" store

