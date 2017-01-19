# Microsoft.DomainRegistration/domains template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.DomainRegistration/domains resource, add the following JSON to the resources section of your template.

```json
{
  "type": "Microsoft.DomainRegistration/domains",
  "apiVersion": "2015-08-01",
  "id": "string",
  "name": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "contactAdmin": {
      "addressMailing": {
        "address1": "string",
        "address2": "string",
        "city": "string",
        "country": "string",
        "postalCode": "string",
        "state": "string"
      },
      "email": "string",
      "fax": "string",
      "jobTitle": "string",
      "nameFirst": "string",
      "nameLast": "string",
      "nameMiddle": "string",
      "organization": "string",
      "phone": "string"
    },
    "contactBilling": {
      "addressMailing": {
        "address1": "string",
        "address2": "string",
        "city": "string",
        "country": "string",
        "postalCode": "string",
        "state": "string"
      },
      "email": "string",
      "fax": "string",
      "jobTitle": "string",
      "nameFirst": "string",
      "nameLast": "string",
      "nameMiddle": "string",
      "organization": "string",
      "phone": "string"
    },
    "contactRegistrant": {
      "addressMailing": {
        "address1": "string",
        "address2": "string",
        "city": "string",
        "country": "string",
        "postalCode": "string",
        "state": "string"
      },
      "email": "string",
      "fax": "string",
      "jobTitle": "string",
      "nameFirst": "string",
      "nameLast": "string",
      "nameMiddle": "string",
      "organization": "string",
      "phone": "string"
    },
    "contactTech": {
      "addressMailing": {
        "address1": "string",
        "address2": "string",
        "city": "string",
        "country": "string",
        "postalCode": "string",
        "state": "string"
      },
      "email": "string",
      "fax": "string",
      "jobTitle": "string",
      "nameFirst": "string",
      "nameLast": "string",
      "nameMiddle": "string",
      "organization": "string",
      "phone": "string"
    },
    "registrationStatus": "string",
    "provisioningState": "string",
    "nameServers": [
      "string"
    ],
    "privacy": boolean,
    "createdTime": "string",
    "expirationTime": "string",
    "lastRenewedTime": "string",
    "autoRenew": boolean,
    "readyForDnsRecordManagement": boolean,
    "managedHostNames": [
      {
        "name": "string",
        "siteNames": [
          "string"
        ],
        "azureResourceName": "string",
        "azureResourceType": "string",
        "customHostNameDnsRecordType": "string",
        "hostNameType": "string"
      }
    ],
    "consent": {
      "agreementKeys": [
        "string"
      ],
      "agreedBy": "string",
      "agreedAt": "string"
    },
    "domainNotRenewableReasons": [
      "string"
    ]
  }
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.DomainRegistration/domains" />
### Microsoft.DomainRegistration/domains object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  type | enum | Yes | Microsoft.DomainRegistration/domains |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Domain_properties object](#Domain_properties) |


<a id="Domain_properties" />
### Domain_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  contactAdmin | object | No | Admin contact information - [Contact object](#Contact) |
|  contactBilling | object | No | Billing contact information - [Contact object](#Contact) |
|  contactRegistrant | object | No | Registrant contact information - [Contact object](#Contact) |
|  contactTech | object | No | Technical contact information - [Contact object](#Contact) |
|  registrationStatus | enum | No | Domain registration status. - Active, Awaiting, Cancelled, Confiscated, Disabled, Excluded, Expired, Failed, Held, Locked, Parked, Pending, Reserved, Reverted, Suspended, Transferred, Unknown, Unlocked, Unparked, Updated, JsonConverterFailed |
|  provisioningState | enum | No | Domain provisioning state. - Succeeded, Failed, Canceled, InProgress, Deleting |
|  nameServers | array | No | Name servers - string |
|  privacy | boolean | No | If true then domain privacy is enabled for this domain |
|  createdTime | string | No | Domain creation timestamp |
|  expirationTime | string | No | Domain expiration timestamp |
|  lastRenewedTime | string | No | Timestamp when the domain was renewed last time |
|  autoRenew | boolean | No | If true then domain will renewed automatically |
|  readyForDnsRecordManagement | boolean | No | If true then Azure can assign this domain to Web Apps. This value will be true if domain registration status is active and it is hosted on name servers Azure has programmatic access to |
|  managedHostNames | array | No | All hostnames derived from the domain and assigned to Azure resources - [HostName object](#HostName) |
|  consent | object | No | Legal agreement consent - [DomainPurchaseConsent object](#DomainPurchaseConsent) |
|  domainNotRenewableReasons | array | No | Reasons why domain is not renewable - RegistrationStatusNotSupportedForRenewal, ExpirationNotInRenewalTimeRange, SubscriptionNotActive |


<a id="Contact" />
### Contact object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  addressMailing | object | No | Mailing address - [Address object](#Address) |
|  email | string | No | Email address |
|  fax | string | No | Fax number |
|  jobTitle | string | No | Job title |
|  nameFirst | string | No | First name |
|  nameLast | string | No | Last name |
|  nameMiddle | string | No | Middle name |
|  organization | string | No | Organization |
|  phone | string | No | Phone number |


<a id="HostName" />
### HostName object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the hostname |
|  siteNames | array | No | List of sites the hostname is assigned to. This list will have more than one site only if the hostname is pointing to a Traffic Manager - string |
|  azureResourceName | string | No | Name of the Azure resource the hostname is assigned to. If it is assigned to a traffic manager then it will be the traffic manager name otherwise it will be the website name |
|  azureResourceType | enum | No | Type of the Azure resource the hostname is assigned to. - Website or TrafficManager |
|  customHostNameDnsRecordType | enum | No | Type of the Dns record. - CName or A |
|  hostNameType | enum | No | Type of the hostname. - Verified or Managed |


<a id="DomainPurchaseConsent" />
### DomainPurchaseConsent object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  agreementKeys | array | No | List of applicable legal agreement keys. This list can be retrieved using ListLegalAgreements Api under TopLevelDomain resource - string |
|  agreedBy | string | No | Client IP address |
|  agreedAt | string | No | Timestamp when the agreements were accepted |


<a id="Address" />
### Address object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  address1 | string | No | Address 1 |
|  address2 | string | No | Address 2 |
|  city | string | No | City |
|  country | string | No | Country |
|  postalCode | string | No | Postal code |
|  state | string | No | State |

