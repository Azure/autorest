# Microsoft.DomainRegistration template schema

Creates a Microsoft.DomainRegistration resource.

## Schema format

To create a Microsoft.DomainRegistration, add the following schema to the resources section of your template.

```
{
  "type": "Microsoft.DomainRegistration/domains",
  "apiVersion": "2015-08-01",
  "location": "string",
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
    "privacy": "boolean",
    "createdTime": "string",
    "expirationTime": "string",
    "lastRenewedTime": "string",
    "autoRenew": "boolean",
    "readyForDnsRecordManagement": "boolean",
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
## Values

The following tables describe the values you need to set in the schema.

<a id="domains" />
## domains object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  type | Yes | enum<br />**Microsoft.DomainRegistration/domains**<br /> |
|  apiVersion | Yes | enum<br />**2015-08-01**<br /> |
|  id | No | string<br /><br />Resource Id |
|  name | No | string<br /><br />Resource Name |
|  kind | No | string<br /><br />Kind of resource |
|  location | Yes | string<br /><br />Resource Location |
|  tags | No | object<br /><br />Resource tags |
|  properties | Yes | object<br />[Domain_properties object](#Domain_properties)<br /> |


<a id="Domain_properties" />
## Domain_properties object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  contactAdmin | No | object<br />[Contact object](#Contact)<br /><br />Admin contact information |
|  contactBilling | No | object<br />[Contact object](#Contact)<br /><br />Billing contact information |
|  contactRegistrant | No | object<br />[Contact object](#Contact)<br /><br />Registrant contact information |
|  contactTech | No | object<br />[Contact object](#Contact)<br /><br />Technical contact information |
|  registrationStatus | No | enum<br />**Active**, **Awaiting**, **Cancelled**, **Confiscated**, **Disabled**, **Excluded**, **Expired**, **Failed**, **Held**, **Locked**, **Parked**, **Pending**, **Reserved**, **Reverted**, **Suspended**, **Transferred**, **Unknown**, **Unlocked**, **Unparked**, **Updated**, **JsonConverterFailed**<br /><br />Domain registration status. |
|  provisioningState | No | enum<br />**Succeeded**, **Failed**, **Canceled**, **InProgress**, **Deleting**<br /><br />Domain provisioning state. |
|  nameServers | No | array<br />**string**<br /><br />Name servers |
|  privacy | No | boolean<br /><br />If true then domain privacy is enabled for this domain |
|  createdTime | No | string<br /><br />Domain creation timestamp |
|  expirationTime | No | string<br /><br />Domain expiration timestamp |
|  lastRenewedTime | No | string<br /><br />Timestamp when the domain was renewed last time |
|  autoRenew | No | boolean<br /><br />If true then domain will renewed automatically |
|  readyForDnsRecordManagement | No | boolean<br /><br />If true then Azure can assign this domain to Web Apps. This value will be true if domain registration status is active and it is hosted on name servers Azure has programmatic access to |
|  managedHostNames | No | array<br />[HostName object](#HostName)<br /><br />All hostnames derived from the domain and assigned to Azure resources |
|  consent | No | object<br />[DomainPurchaseConsent object](#DomainPurchaseConsent)<br /><br />Legal agreement consent |
|  domainNotRenewableReasons | No | array<br />**RegistrationStatusNotSupportedForRenewal**, **ExpirationNotInRenewalTimeRange**, **SubscriptionNotActive**<br /><br />Reasons why domain is not renewable |


<a id="Contact" />
## Contact object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  addressMailing | No | object<br />[Address object](#Address)<br /><br />Mailing address |
|  email | No | string<br /><br />Email address |
|  fax | No | string<br /><br />Fax number |
|  jobTitle | No | string<br /><br />Job title |
|  nameFirst | No | string<br /><br />First name |
|  nameLast | No | string<br /><br />Last name |
|  nameMiddle | No | string<br /><br />Middle name |
|  organization | No | string<br /><br />Organization |
|  phone | No | string<br /><br />Phone number |


<a id="Address" />
## Address object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  address1 | No | string<br /><br />Address 1 |
|  address2 | No | string<br /><br />Address 2 |
|  city | No | string<br /><br />City |
|  country | No | string<br /><br />Country |
|  postalCode | No | string<br /><br />Postal code |
|  state | No | string<br /><br />State |


<a id="HostName" />
## HostName object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  name | No | string<br /><br />Name of the hostname |
|  siteNames | No | array<br />**string**<br /><br />List of sites the hostname is assigned to. This list will have more than one site only if the hostname is pointing to a Traffic Manager |
|  azureResourceName | No | string<br /><br />Name of the Azure resource the hostname is assigned to. If it is assigned to a traffic manager then it will be the traffic manager name otherwise it will be the website name |
|  azureResourceType | No | enum<br />**Website** or **TrafficManager**<br /><br />Type of the Azure resource the hostname is assigned to. |
|  customHostNameDnsRecordType | No | enum<br />**CName** or **A**<br /><br />Type of the Dns record. |
|  hostNameType | No | enum<br />**Verified** or **Managed**<br /><br />Type of the hostname. |


<a id="DomainPurchaseConsent" />
## DomainPurchaseConsent object
|  Name | Required | Value |
|  ---- | ---- | ---- |
|  agreementKeys | No | array<br />**string**<br /><br />List of applicable legal agreement keys. This list can be retrieved using ListLegalAgreements Api under TopLevelDomain resource |
|  agreedBy | No | string<br /><br />Client IP address |
|  agreedAt | No | string<br /><br />Timestamp when the agreements were accepted |

