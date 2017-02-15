# Microsoft.CertificateRegistration/certificateOrders template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.CertificateRegistration/certificateOrders resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.CertificateRegistration/certificateOrders",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "certificates": {},
    "distinguishedName": "string",
    "domainVerificationToken": "string",
    "validityInYears": "integer",
    "keySize": "integer",
    "productType": "string",
    "autoRenew": boolean,
    "provisioningState": "string",
    "status": "string",
    "signedCertificate": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "version": "integer",
        "serialNumber": "string",
        "thumbprint": "string",
        "subject": "string",
        "notBefore": "string",
        "notAfter": "string",
        "signatureAlgorithm": "string",
        "issuer": "string",
        "rawData": "string"
      }
    },
    "csr": "string",
    "intermediate": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "version": "integer",
        "serialNumber": "string",
        "thumbprint": "string",
        "subject": "string",
        "notBefore": "string",
        "notAfter": "string",
        "signatureAlgorithm": "string",
        "issuer": "string",
        "rawData": "string"
      }
    },
    "root": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "version": "integer",
        "serialNumber": "string",
        "thumbprint": "string",
        "subject": "string",
        "notBefore": "string",
        "notAfter": "string",
        "signatureAlgorithm": "string",
        "issuer": "string",
        "rawData": "string"
      }
    },
    "serialNumber": "string",
    "lastCertificateIssuanceTime": "string",
    "expirationTime": "string"
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.CertificateRegistration/certificateOrders" />
### Microsoft.CertificateRegistration/certificateOrders object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.CertificateRegistration/certificateOrders |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [CertificateOrder_properties object](#CertificateOrder_properties) |
|  resources | array | No | [certificateOrders_certificates_childResource object](#certificateOrders_certificates_childResource) |


<a id="CertificateOrder_properties" />
### CertificateOrder_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  certificates | object | No | State of the Key Vault secret |
|  distinguishedName | string | No | Certificate distinguished name |
|  domainVerificationToken | string | No | Domain Verification Token |
|  validityInYears | integer | No | Duration in years (must be between 1 and 3) |
|  keySize | integer | No | Certificate Key Size |
|  productType | enum | No | Certificate product type. - StandardDomainValidatedSsl or StandardDomainValidatedWildCardSsl |
|  autoRenew | boolean | No | Auto renew |
|  provisioningState | enum | No | Status of certificate order. - Succeeded, Failed, Canceled, InProgress, Deleting |
|  status | enum | No | Current order status. - Pendingissuance, Issued, Revoked, Canceled, Denied, Pendingrevocation, PendingRekey, Unused, Expired, NotSubmitted |
|  signedCertificate | object | No | Signed certificate - [CertificateDetails object](#CertificateDetails) |
|  csr | string | No | Last CSR that was created for this order |
|  intermediate | object | No | Intermediate certificate - [CertificateDetails object](#CertificateDetails) |
|  root | object | No | Root certificate - [CertificateDetails object](#CertificateDetails) |
|  serialNumber | string | No | Current serial number of the certificate |
|  lastCertificateIssuanceTime | string | No | Certificate last issuance time |
|  expirationTime | string | No | Certificate expiration time |


<a id="certificateOrders_certificates_childResource" />
### certificateOrders_certificates_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | certificates |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [CertificateOrderCertificate_properties object](#CertificateOrderCertificate_properties) |


<a id="CertificateDetails" />
### CertificateDetails object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  type | string | No | Resource type |
|  tags | object | No | Resource tags |
|  properties | object | No | [CertificateDetails_properties object](#CertificateDetails_properties) |


<a id="CertificateOrderCertificate_properties" />
### CertificateOrderCertificate_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  keyVaultId | string | No | Key Vault Csm resource Id |
|  keyVaultSecretName | string | No | Key Vault secret name |
|  provisioningState | enum | No | Status of the Key Vault secret. - Initialized, WaitingOnCertificateOrder, Succeeded, CertificateOrderFailed, OperationNotPermittedOnKeyVault, AzureServiceUnauthorizedToAccessKeyVault, KeyVaultDoesNotExist, KeyVaultSecretDoesNotExist, UnknownError, Unknown |


<a id="CertificateDetails_properties" />
### CertificateDetails_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  version | integer | No | Version |
|  serialNumber | string | No | Serial Number |
|  thumbprint | string | No | Thumbprint |
|  subject | string | No | Subject |
|  notBefore | string | No | Valid from |
|  notAfter | string | No | Valid to |
|  signatureAlgorithm | string | No | Signature Algorithm |
|  issuer | string | No | Issuer |
|  rawData | string | No | Raw certificate data |

