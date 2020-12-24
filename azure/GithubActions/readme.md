adapted from:
https://www.blendmastersoftware.com/blog/deploying-to-azure-using-terraform-and-github-actions
 
changes:
- added actions to open/close Az storage account (used for TF remote state) firewall on the fly
- TF 0.14 provider reqs
- issue described below
 
to fix issue accessing remote backend

https://terraformwithkushagra.blogspot.com/2019/12/error-inspecting-states-in-azurerm.html

1/ delete .terraform folder
2/ run
terraform init -backend-config="access_key=$(az storage account keys list --resource-group "tstate" --account-name "tstate25079" --query '[0].value' -o tsv)"

Error:

TF_LOG=TRACE terraform init
2020/12/22 09:31:28 [INFO] Terraform version: 0.14.2
2020/12/22 09:31:28 [INFO] Go runtime version: go1.15.2
2020/12/22 09:31:28 [INFO] CLI args: []string{"/usr/local/bin/terraform", "init"}
2020/12/22 09:31:28 [DEBUG] Attempting to open CLI config file: /home/steph/.terraformrc
2020/12/22 09:31:28 [DEBUG] File doesn't exist, but doesn't need to. Ignoring.
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory terraform.d/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /home/steph/.terraform.d/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /home/steph/.local/share/terraform/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /home/steph/.local/share/flatpak/exports/share/terraform/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /var/lib/flatpak/exports/share/terraform/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /usr/local/share/terraform/plugins
2020/12/22 09:31:28 [DEBUG] ignoring non-existing provider search directory /usr/share/terraform/plugins

Initializing the backend...
2020/12/22 09:31:28 [INFO] CLI command args: []string{"init"}
2020/12/22 09:31:28 [TRACE] Meta.Backend: built configuration for "azurerm" backend with hash value 617642557
2020/12/22 09:31:28 [TRACE] Preserving existing state lineage "12446581-8bec-bd81-8f97-82a18970266f"
2020/12/22 09:31:28 [TRACE] Preserving existing state lineage "12446581-8bec-bd81-8f97-82a18970266f"
2020/12/22 09:31:28 [TRACE] Meta.Backend: working directory was previously initialized for "azurerm" backend
2020/12/22 09:31:28 [TRACE] Meta.Backend: using already-initialized, unchanged "azurerm" backend configuration
2020/12/22 09:31:28 [DEBUG] Azure Backend Request:
GET /tstate?comp=list&prefix=terraform.tfstateenv%3A&restype=container HTTP/1.1
Host: tstate25079.blob.core.windows.net
User-Agent: Terraform/0.14.2
Content-Type: application/xml; charset=utf-8
X-Ms-Date: Tue, 22 Dec 2020 08:31:28 GMT
X-Ms-Version: 2018-11-09
Accept-Encoding: gzip



2020/12/22 09:31:29 [DEBUG] Azure Backend Response for https://tstate25079.blob.core.windows.net/tstate?comp=list&prefix=terraform.tfstateenv%3A&restype=container:
HTTP/1.1 403 Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.
Content-Length: 735
Content-Type: application/xml
Date: Tue, 22 Dec 2020 08:31:29 GMT
Server: Microsoft-HTTPAPI/2.0
X-Ms-Error-Code: AuthenticationFailed
X-Ms-Request-Id: bf7f89bb-701e-008a-3e3c-d880f1000000

<?xml version="1.0" encoding="utf-8"?><Error><Code>AuthenticationFailed</Code><Message>Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.
RequestId:bf7f89bb-701e-008a-3e3c-d880f1000000
Time:2020-12-22T08:31:29.5801406Z</Message><AuthenticationErrorDetail>The MAC signature found in the HTTP request '<redacted>' is not the same as any computed signature. Server used following string to sign: 'GET




application/xml; charset=utf-8






x-ms-date:Tue, 22 Dec 2020 08:31:28 GMT
x-ms-version:2018-11-09
/tstate25079/tstate
comp:list
prefix:terraform.tfstateenv:
restype:container'.</AuthenticationErrorDetail></Error>
Error: Failed to get existing workspaces: containers.Client#ListBlobs: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="AuthenticationFailed" Message="Server failed to authenticate the request. Make sure the value of Authorization header is formed correctly including the signature.\nRequestId:bf7f89bb-701e-008a-3e3c-d880f1000000\nTime:2020-12-22T08:31:29.5801406Z"

