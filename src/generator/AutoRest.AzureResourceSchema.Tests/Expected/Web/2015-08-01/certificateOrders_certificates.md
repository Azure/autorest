# Microsoft.CertificateRegistration/certificateOrders/certificates template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.CertificateRegistration/certificateOrders/certificates resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.CertificateRegistration/certificateOrders/certificates",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "keyVaultId": "string",
    "keyVaultSecretName": "string",
    "provisioningState": "string"
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.CertificateRegistration/certificateOrders/certificates" />
### Microsoft.CertificateRegistration/certificateOrders/certificates object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.CertificateRegistration/certificateOrders/certificates |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [CertificateOrderCertificate_properties object](#CertificateOrderCertificate_properties) |


<a id="CertificateOrderCertificate_properties" />
### CertificateOrderCertificate_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  keyVaultId | string | No | Key Vault Csm resource Id |
|  keyVaultSecretName | string | No | Key Vault secret name |
|  provisioningState | enum | No | Status of the Key Vault secret. - Initialized, WaitingOnCertificateOrder, Succeeded, CertificateOrderFailed, OperationNotPermittedOnKeyVault, AzureServiceUnauthorizedToAccessKeyVault, KeyVaultDoesNotExist, KeyVaultSecretDoesNotExist, UnknownError, Unknown |

