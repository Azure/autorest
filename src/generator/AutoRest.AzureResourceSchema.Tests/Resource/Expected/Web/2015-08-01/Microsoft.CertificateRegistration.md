# Microsoft.CertificateRegistration template schema

Creates a Microsoft.CertificateRegistration resource.

## Schema format

To create a Microsoft.CertificateRegistration, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.CertificateRegistration/certificateOrders/certificates",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "keyVaultId": "string",
    "keyVaultSecretName": "string",
    "provisioningState": "string"
  }
}
```
```
{
  "type": "Microsoft.CertificateRegistration/certificateOrders",
  "apiVersion": "2015-08-01",
  "location": "string",
  "properties": {
    "certificates": {},
    "distinguishedName": "string",
    "domainVerificationToken": "string",
    "validityInYears": "integer",
    "keySize": "integer",
    "productType": "string",
    "autoRenew": "boolean",
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
  }
}
```
## Values

The following tables describe the values you need to set in the schema.

<a id="certificateOrders_certificates" />
## certificateOrders_certificates object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.CertificateRegistration/certificateOrders/certificates**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[CertificateOrderCertificate_properties object](#CertificateOrderCertificate_properties)<br /> |


<a id="certificateOrders" />
## certificateOrders object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.CertificateRegistration/certificateOrders**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[CertificateOrder_properties object](#CertificateOrder_properties)<br /> |
|  resources | No | array<br />[certificates object](#certificates)<br /> |


<a id="CertificateOrderCertificate_properties" />
## CertificateOrderCertificate_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  keyVaultId | No | string<br /><br />Key Vault Csm resource Id |
|  keyVaultSecretName | No | string<br /><br />Key Vault secret name |
|  provisioningState | No | enum<br />**Initialized**, **WaitingOnCertificateOrder**, **Succeeded**, **CertificateOrderFailed**, **OperationNotPermittedOnKeyVault**, **AzureServiceUnauthorizedToAccessKeyVault**, **KeyVaultDoesNotExist**, **KeyVaultSecretDoesNotExist**, **UnknownError**, **Unknown**<br /><br />Status of the Key Vault secret. |


<a id="CertificateOrder_properties" />
## CertificateOrder_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  certificates | No | object<br /><br />State of the Key Vault secret |
|  distinguishedName | No | string<br /><br />Certificate distinguished name |
|  domainVerificationToken | No | string<br /><br />Domain Verification Token |
|  validityInYears | No | integer<br /><br />Duration in years (must be between 1 and 3) |
|  keySize | No | integer<br /><br />Certificate Key Size |
|  productType | No | enum<br />**StandardDomainValidatedSsl** or **StandardDomainValidatedWildCardSsl**<br /><br />Certificate product type. |
|  autoRenew | No | boolean<br /><br />Auto renew |
|  provisioningState | No | enum<br />**Succeeded**, **Failed**, **Canceled**, **InProgress**, **Deleting**<br /><br />Status of certificate order. |
|  status | No | enum<br />**Pendingissuance**, **Issued**, **Revoked**, **Canceled**, **Denied**, **Pendingrevocation**, **PendingRekey**, **Unused**, **Expired**, **NotSubmitted**<br /><br />Current order status. |
|  signedCertificate | No | object<br />[CertificateDetails object](#CertificateDetails)<br /><br />Signed certificate |
|  csr | No | string<br /><br />Last CSR that was created for this order |
|  intermediate | No | object<br />[CertificateDetails object](#CertificateDetails)<br /><br />Intermediate certificate |
|  root | No | object<br />[CertificateDetails object](#CertificateDetails)<br /><br />Root certificate |
|  serialNumber | No | string<br /><br />Current serial number of the certificate |
|  lastCertificateIssuanceTime | No | string<br /><br />Certificate last issuance time |
|  expirationTime | No | string<br /><br />Certificate expiration time |


<a id="CertificateOrderCertificate" />
## CertificateOrderCertificate object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  type | No | string<br /><br />Resource type |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[CertificateOrderCertificate_properties object](#CertificateOrderCertificate_properties)<br /> |


<a id="CertificateDetails" />
## CertificateDetails object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  type | No | string<br /><br />Resource type |
|  tags | No | object<br /><br />Resource tags |
|  properties | No | object<br />[CertificateDetails_properties object](#CertificateDetails_properties)<br /> |


<a id="CertificateDetails_properties" />
## CertificateDetails_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  version | No | integer<br /><br />Version |
|  serialNumber | No | string<br /><br />Serial Number |
|  thumbprint | No | string<br /><br />Thumbprint |
|  subject | No | string<br /><br />Subject |
|  notBefore | No | string<br /><br />Valid from |
|  notAfter | No | string<br /><br />Valid to |
|  signatureAlgorithm | No | string<br /><br />Signature Algorithm |
|  issuer | No | string<br /><br />Issuer |
|  rawData | No | string<br /><br />Raw certificate data |


<a id="certificateOrders_certificates_childResource" />
## certificateOrders_certificates_childResource object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**certificates**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[CertificateOrderCertificate_properties object](#CertificateOrderCertificate_properties)<br /> |

