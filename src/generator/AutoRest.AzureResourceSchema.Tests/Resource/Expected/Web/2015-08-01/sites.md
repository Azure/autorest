# Microsoft.Web/sites template reference
API Version: 2015-08-01
## Template format

To create a Microsoft.Web/sites resource, add the following JSON to the resources section of your template.

```json
{
  "name": "string",
  "type": "Microsoft.Web/sites",
  "apiVersion": "2015-08-01",
  "id": "string",
  "kind": "string",
  "location": "string",
  "tags": {},
  "properties": {
    "name": "string",
    "enabled": boolean,
    "hostNameSslStates": [
      {
        "name": "string",
        "sslState": "string",
        "virtualIP": "string",
        "thumbprint": "string",
        "toUpdate": boolean
      }
    ],
    "serverFarmId": "string",
    "siteConfig": {
      "id": "string",
      "name": "string",
      "kind": "string",
      "location": "string",
      "type": "string",
      "tags": {},
      "properties": {
        "numberOfWorkers": "integer",
        "defaultDocuments": [
          "string"
        ],
        "netFrameworkVersion": "string",
        "phpVersion": "string",
        "pythonVersion": "string",
        "requestTracingEnabled": boolean,
        "requestTracingExpirationTime": "string",
        "remoteDebuggingEnabled": boolean,
        "remoteDebuggingVersion": "string",
        "httpLoggingEnabled": boolean,
        "logsDirectorySizeLimit": "integer",
        "detailedErrorLoggingEnabled": boolean,
        "publishingUsername": "string",
        "publishingPassword": "string",
        "appSettings": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "metadata": [
          {
            "name": "string",
            "value": "string"
          }
        ],
        "connectionStrings": [
          {
            "name": "string",
            "connectionString": "string",
            "type": "string"
          }
        ],
        "handlerMappings": [
          {
            "extension": "string",
            "scriptProcessor": "string",
            "arguments": "string"
          }
        ],
        "documentRoot": "string",
        "scmType": "string",
        "use32BitWorkerProcess": boolean,
        "webSocketsEnabled": boolean,
        "alwaysOn": boolean,
        "javaVersion": "string",
        "javaContainer": "string",
        "javaContainerVersion": "string",
        "managedPipelineMode": "string",
        "virtualApplications": [
          {
            "virtualPath": "string",
            "physicalPath": "string",
            "preloadEnabled": boolean,
            "virtualDirectories": [
              {
                "virtualPath": "string",
                "physicalPath": "string"
              }
            ]
          }
        ],
        "loadBalancing": "string",
        "experiments": {
          "rampUpRules": [
            {
              "actionHostName": "string",
              "reroutePercentage": "number",
              "changeStep": "number",
              "changeIntervalInMinutes": "integer",
              "minReroutePercentage": "number",
              "maxReroutePercentage": "number",
              "changeDecisionCallbackUrl": "string",
              "name": "string"
            }
          ]
        },
        "limits": {
          "maxPercentageCpu": "number",
          "maxMemoryInMb": "integer",
          "maxDiskSizeInMb": "integer"
        },
        "autoHealEnabled": boolean,
        "autoHealRules": {
          "triggers": {
            "requests": {
              "count": "integer",
              "timeInterval": "string"
            },
            "privateBytesInKB": "integer",
            "statusCodes": [
              {
                "status": "integer",
                "subStatus": "integer",
                "win32Status": "integer",
                "count": "integer",
                "timeInterval": "string"
              }
            ],
            "slowRequests": {
              "timeTaken": "string",
              "count": "integer",
              "timeInterval": "string"
            }
          },
          "actions": {
            "actionType": "string",
            "customAction": {
              "exe": "string",
              "parameters": "string"
            },
            "minProcessExecutionTime": "string"
          }
        },
        "tracingOptions": "string",
        "vnetName": "string",
        "cors": {
          "allowedOrigins": [
            "string"
          ]
        },
        "apiDefinition": {
          "url": "string"
        },
        "autoSwapSlotName": "string",
        "localMySqlEnabled": boolean,
        "ipSecurityRestrictions": [
          {
            "ipAddress": "string",
            "subnetMask": "string"
          }
        ]
      }
    },
    "scmSiteAlsoStopped": boolean,
    "hostingEnvironmentProfile": {
      "id": "string",
      "name": "string",
      "type": "string"
    },
    "microService": "string",
    "gatewaySiteName": "string",
    "clientAffinityEnabled": boolean,
    "clientCertEnabled": boolean,
    "hostNamesDisabled": boolean,
    "containerSize": "integer",
    "maxNumberOfWorkers": "integer",
    "cloningInfo": {
      "correlationId": "string",
      "overwrite": boolean,
      "cloneCustomHostNames": boolean,
      "cloneSourceControl": boolean,
      "sourceWebAppId": "string",
      "hostingEnvironment": "string",
      "appSettingsOverrides": {},
      "configureLoadBalancing": boolean,
      "trafficManagerProfileId": "string",
      "trafficManagerProfileName": "string"
    }
  },
  "resources": [
    null
  ]
}
```
## Property values

The following tables describe the values you need to set in the schema.

<a id="Microsoft.Web/sites" />
### Microsoft.Web/sites object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | Microsoft.Web/sites |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Site_properties object](#Site_properties) |
|  resources | array | No | [sites_hybridconnection_childResource object](#sites_hybridconnection_childResource) [sites_premieraddons_childResource object](#sites_premieraddons_childResource) [sites_hostNameBindings_childResource object](#sites_hostNameBindings_childResource) [sites_deployments_childResource object](#sites_deployments_childResource) [sites_slots_childResource object](#sites_slots_childResource) [sites_virtualNetworkConnections_childResource object](#sites_virtualNetworkConnections_childResource) |


<a id="Site_properties" />
### Site_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of web app |
|  enabled | boolean | No | True if the site is enabled; otherwise, false. Setting this  value to false disables the site (takes the site off line). |
|  hostNameSslStates | array | No | Hostname SSL states are  used to manage the SSL bindings for site's hostnames. - [HostNameSslState object](#HostNameSslState) |
|  serverFarmId | string | No |  |
|  siteConfig | object | No | Configuration of web app - [SiteConfig object](#SiteConfig) |
|  scmSiteAlsoStopped | boolean | No | If set indicates whether to stop SCM (KUDU) site when the web app is stopped. Default is false. |
|  hostingEnvironmentProfile | object | No | Specification for the hosting environment (App Service Environment) to use for the web app - [HostingEnvironmentProfile object](#HostingEnvironmentProfile) |
|  microService | string | No |  |
|  gatewaySiteName | string | No | Name of gateway app associated with web app |
|  clientAffinityEnabled | boolean | No | Specifies if the client affinity is enabled when load balancing http request for multiple instances of the web app |
|  clientCertEnabled | boolean | No | Specifies if the client certificate is enabled for the web app |
|  hostNamesDisabled | boolean | No | Specifies if the public hostnames are disabled the web app.
            If set to true the app is only accessible via API Management process |
|  containerSize | integer | No | Size of a function container |
|  maxNumberOfWorkers | integer | No | Maximum number of workers
            This only applies to function container |
|  cloningInfo | object | No | This is only valid for web app creation. If specified, web app is cloned from
            a source web app - [CloningInfo object](#CloningInfo) |


<a id="sites_hybridconnection_childResource" />
### sites_hybridconnection_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | hybridconnection |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties) |


<a id="sites_premieraddons_childResource" />
### sites_premieraddons_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | premieraddons |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | object | No | Tags associated with resource |
|  plan | object | No | Azure resource manager plan - [ArmPlan object](#ArmPlan) |
|  properties | object | Yes | Resource specific properties |
|  sku | object | No | Sku description of the resource - [SkuDescription object](#SkuDescription) |


<a id="sites_hostNameBindings_childResource" />
### sites_hostNameBindings_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | hostNameBindings |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [HostNameBinding_properties object](#HostNameBinding_properties) |


<a id="sites_deployments_childResource" />
### sites_deployments_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | deployments |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Deployment_properties object](#Deployment_properties) |


<a id="sites_slots_childResource" />
### sites_slots_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | slots |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Site_properties object](#Site_properties) |
|  resources | array | No | [sites_slots_hybridconnection_childResource object](#sites_slots_hybridconnection_childResource) [sites_slots_premieraddons_childResource object](#sites_slots_premieraddons_childResource) [sites_slots_hostNameBindings_childResource object](#sites_slots_hostNameBindings_childResource) [sites_slots_deployments_childResource object](#sites_slots_deployments_childResource) |


<a id="sites_virtualNetworkConnections_childResource" />
### sites_virtualNetworkConnections_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | virtualNetworkConnections |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VnetInfo_properties object](#VnetInfo_properties) |
|  resources | array | No | [sites_virtualNetworkConnections_gateways_childResource object](#sites_virtualNetworkConnections_gateways_childResource) |


<a id="HostNameSslState" />
### HostNameSslState object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Host name |
|  sslState | enum | Yes | SSL type. - Disabled, SniEnabled, IpBasedEnabled |
|  virtualIP | string | No | Virtual IP address assigned to the host name if IP based SSL is enabled |
|  thumbprint | string | No | SSL cert thumbprint |
|  toUpdate | boolean | No | Set this flag to update existing host name |


<a id="SiteConfig" />
### SiteConfig object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  type | string | No | Resource type |
|  tags | object | No | Resource tags |
|  properties | object | No | [SiteConfig_properties object](#SiteConfig_properties) |


<a id="HostingEnvironmentProfile" />
### HostingEnvironmentProfile object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource id of the hostingEnvironment (App Service Environment) |
|  name | string | No | Name of the hostingEnvironment (App Service Environment) (read only) |
|  type | string | No | Resource type of the hostingEnvironment (App Service Environment) (read only) |


<a id="CloningInfo" />
### CloningInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  correlationId | string | No | Correlation Id of cloning operation. This id ties multiple cloning operations
            together to use the same snapshot |
|  overwrite | boolean | No | Overwrite destination web app |
|  cloneCustomHostNames | boolean | No | If true, clone custom hostnames from source web app |
|  cloneSourceControl | boolean | No | Clone source control from source web app |
|  sourceWebAppId | string | No | ARM resource id of the source web app. Web app resource id is of the form
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName} for production slots and
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Web/sites/{siteName}/slots/{slotName} for other slots |
|  hostingEnvironment | string | No | Hosting environment |
|  appSettingsOverrides | object | No | Application settings overrides for cloned web app. If specified these settings will override the settings cloned
            from source web app. If not specified, application settings from source web app are retained. |
|  configureLoadBalancing | boolean | No | If specified configure load balancing for source and clone site |
|  trafficManagerProfileId | string | No | ARM resource id of the traffic manager profile to use if it exists. Traffic manager resource id is of the form
            /subscriptions/{subId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/trafficManagerProfiles/{profileName} |
|  trafficManagerProfileName | string | No | Name of traffic manager profile to create. This is only needed if traffic manager profile does not already exist |


<a id="RelayServiceConnectionEntity_properties" />
### RelayServiceConnectionEntity_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  entityName | string | No |  |
|  entityConnectionString | string | No |  |
|  resourceType | string | No |  |
|  resourceConnectionString | string | No |  |
|  hostname | string | No |  |
|  port | integer | No |  |
|  biztalkUri | string | No |  |


<a id="ArmPlan" />
### ArmPlan object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name |
|  publisher | string | No | The publisher |
|  product | string | No | The product |
|  promotionCode | string | No | The promotion code |
|  version | string | No | Version of product |


<a id="SkuDescription" />
### SkuDescription object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of the resource sku |
|  tier | string | No | Service Tier of the resource sku |
|  size | string | No | Size specifier of the resource sku |
|  family | string | No | Family code of the resource sku |
|  capacity | integer | No | Current number of instances assigned to the resource |


<a id="HostNameBinding_properties" />
### HostNameBinding_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Hostname |
|  siteName | string | No | Web app name |
|  domainId | string | No | Fully qualified ARM domain resource URI |
|  azureResourceName | string | No | Azure resource name |
|  azureResourceType | enum | No | Azure resource type. - Website or TrafficManager |
|  customHostNameDnsRecordType | enum | No | Custom DNS record type. - CName or A |
|  hostNameType | enum | No | Host name type. - Verified or Managed |


<a id="Deployment_properties" />
### Deployment_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Id |
|  status | integer | No | Status |
|  message | string | No | Message |
|  author | string | No | Author |
|  deployer | string | No | Deployer |
|  author_email | string | No | AuthorEmail |
|  start_time | string | No | StartTime |
|  end_time | string | No | EndTime |
|  active | boolean | No | Active |
|  details | string | No | Detail |


<a id="sites_slots_hybridconnection_childResource" />
### sites_slots_hybridconnection_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | hybridconnection |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [RelayServiceConnectionEntity_properties object](#RelayServiceConnectionEntity_properties) |


<a id="sites_slots_premieraddons_childResource" />
### sites_slots_premieraddons_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | premieraddons |
|  apiVersion | enum | Yes | 2015-08-01 |
|  location | string | No | Geo region resource belongs to e.g. SouthCentralUS, SouthEastAsia |
|  tags | object | No | Tags associated with resource |
|  plan | object | No | Azure resource manager plan - [ArmPlan object](#ArmPlan) |
|  properties | object | Yes | Resource specific properties |
|  sku | object | No | Sku description of the resource - [SkuDescription object](#SkuDescription) |


<a id="sites_slots_hostNameBindings_childResource" />
### sites_slots_hostNameBindings_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | hostNameBindings |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [HostNameBinding_properties object](#HostNameBinding_properties) |


<a id="sites_slots_deployments_childResource" />
### sites_slots_deployments_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | deployments |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [Deployment_properties object](#Deployment_properties) |


<a id="VnetInfo_properties" />
### VnetInfo_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vnetResourceId | string | No | The vnet resource id |
|  certThumbprint | string | No | The client certificate thumbprint |
|  certBlob | string | No | A certificate file (.cer) blob containing the public key of the private key used to authenticate a
            Point-To-Site VPN connection. |
|  routes | array | No | The routes that this virtual network connection uses. - [VnetRoute object](#VnetRoute) |
|  resyncRequired | boolean | No | Flag to determine if a resync is required |
|  dnsServers | string | No | Dns servers to be used by this VNET. This should be a comma-separated list of IP addresses. |


<a id="sites_virtualNetworkConnections_gateways_childResource" />
### sites_virtualNetworkConnections_gateways_childResource object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | Yes |  |
|  type | enum | Yes | gateways |
|  apiVersion | enum | Yes | 2015-08-01 |
|  id | string | No | Resource Id |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  tags | object | No | Resource tags |
|  properties | object | Yes | [VnetGateway_properties object](#VnetGateway_properties) |


<a id="SiteConfig_properties" />
### SiteConfig_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  numberOfWorkers | integer | No | Number of workers |
|  defaultDocuments | array | No | Default documents - string |
|  netFrameworkVersion | string | No | Net Framework Version |
|  phpVersion | string | No | Version of PHP |
|  pythonVersion | string | No | Version of Python |
|  requestTracingEnabled | boolean | No | Enable request tracing |
|  requestTracingExpirationTime | string | No | Request tracing expiration time |
|  remoteDebuggingEnabled | boolean | No | Remote Debugging Enabled |
|  remoteDebuggingVersion | string | No | Remote Debugging Version |
|  httpLoggingEnabled | boolean | No | HTTP logging Enabled |
|  logsDirectorySizeLimit | integer | No | HTTP Logs Directory size limit |
|  detailedErrorLoggingEnabled | boolean | No | Detailed error logging enabled |
|  publishingUsername | string | No | Publishing user name |
|  publishingPassword | string | No | Publishing password |
|  appSettings | array | No | Application Settings - [NameValuePair object](#NameValuePair) |
|  metadata | array | No | Site Metadata - [NameValuePair object](#NameValuePair) |
|  connectionStrings | array | No | Connection strings - [ConnStringInfo object](#ConnStringInfo) |
|  handlerMappings | array | No | Handler mappings - [HandlerMapping object](#HandlerMapping) |
|  documentRoot | string | No | Document root |
|  scmType | string | No | SCM type |
|  use32BitWorkerProcess | boolean | No | Use 32 bit worker process |
|  webSocketsEnabled | boolean | No | Web socket enabled. |
|  alwaysOn | boolean | No | Always On |
|  javaVersion | string | No | Java version |
|  javaContainer | string | No | Java container |
|  javaContainerVersion | string | No | Java container version |
|  managedPipelineMode | enum | No | Managed pipeline mode. - Integrated or Classic |
|  virtualApplications | array | No | Virtual applications - [VirtualApplication object](#VirtualApplication) |
|  loadBalancing | enum | No | Site load balancing. - WeightedRoundRobin, LeastRequests, LeastResponseTime, WeightedTotalTraffic, RequestHash |
|  experiments | object | No | This is work around for polymophic types - [Experiments object](#Experiments) |
|  limits | object | No | Site limits - [SiteLimits object](#SiteLimits) |
|  autoHealEnabled | boolean | No | Auto heal enabled |
|  autoHealRules | object | No | Auto heal rules - [AutoHealRules object](#AutoHealRules) |
|  tracingOptions | string | No | Tracing options |
|  vnetName | string | No | Vnet name |
|  cors | object | No | Cross-Origin Resource Sharing (CORS) settings. - [CorsSettings object](#CorsSettings) |
|  apiDefinition | object | No | Information about the formal API definition for the web app. - [ApiDefinitionInfo object](#ApiDefinitionInfo) |
|  autoSwapSlotName | string | No | Auto swap slot name |
|  localMySqlEnabled | boolean | No | Local mysql enabled |
|  ipSecurityRestrictions | array | No | Ip Security restrictions - [IpSecurityRestriction object](#IpSecurityRestriction) |


<a id="VnetRoute" />
### VnetRoute object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  id | string | No | Resource Id |
|  name | string | No | Resource Name |
|  kind | string | No | Kind of resource |
|  location | string | Yes | Resource Location |
|  type | string | No | Resource type |
|  tags | object | No | Resource tags |
|  properties | object | No | [VnetRoute_properties object](#VnetRoute_properties) |


<a id="VnetGateway_properties" />
### VnetGateway_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  vnetName | string | No | The VNET name. |
|  vpnPackageUri | string | No | The URI where the Vpn package can be downloaded |


<a id="NameValuePair" />
### NameValuePair object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Pair name |
|  value | string | No | Pair value |


<a id="ConnStringInfo" />
### ConnStringInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | Name of connection string |
|  connectionString | string | No | Connection string value |
|  type | enum | Yes | Type of database. - MySql, SQLServer, SQLAzure, Custom |


<a id="HandlerMapping" />
### HandlerMapping object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  extension | string | No | Requests with this extension will be handled using the specified FastCGI application. |
|  scriptProcessor | string | No | The absolute path to the FastCGI application. |
|  arguments | string | No | Command-line arguments to be passed to the script processor. |


<a id="VirtualApplication" />
### VirtualApplication object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualPath | string | No |  |
|  physicalPath | string | No |  |
|  preloadEnabled | boolean | No |  |
|  virtualDirectories | array | No | [VirtualDirectory object](#VirtualDirectory) |


<a id="Experiments" />
### Experiments object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  rampUpRules | array | No | List of {Microsoft.Web.Hosting.Administration.RampUpRule} objects. - [RampUpRule object](#RampUpRule) |


<a id="SiteLimits" />
### SiteLimits object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  maxPercentageCpu | number | No | Maximum allowed CPU usage percentage |
|  maxMemoryInMb | integer | No | Maximum allowed memory usage in MB |
|  maxDiskSizeInMb | integer | No | Maximum allowed disk size usage in MB |


<a id="AutoHealRules" />
### AutoHealRules object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  triggers | object | No | Triggers - Conditions that describe when to execute the auto-heal actions - [AutoHealTriggers object](#AutoHealTriggers) |
|  actions | object | No | Actions - Actions to be executed when a rule is triggered - [AutoHealActions object](#AutoHealActions) |


<a id="CorsSettings" />
### CorsSettings object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  allowedOrigins | array | No | Gets or sets the list of origins that should be allowed to make cross-origin
            calls (for example: http://example.com:12345). Use "*" to allow all. - string |


<a id="ApiDefinitionInfo" />
### ApiDefinitionInfo object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  url | string | No | The URL of the API definition. |


<a id="IpSecurityRestriction" />
### IpSecurityRestriction object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  ipAddress | string | No | IP address the security restriction is valid for |
|  subnetMask | string | No | Subnet mask for the range of IP addresses the restriction is valid for |


<a id="VnetRoute_properties" />
### VnetRoute_properties object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  name | string | No | The name of this route. This is only returned by the server and does not need to be set by the client. |
|  startAddress | string | No | The starting address for this route. This may also include a CIDR notation, in which case the end address must not be specified. |
|  endAddress | string | No | The ending address for this route. If the start address is specified in CIDR notation, this must be omitted. |
|  routeType | string | No | The type of route this is:
            DEFAULT - By default, every web app has routes to the local address ranges specified by RFC1918
            INHERITED - Routes inherited from the real Virtual Network routes
            STATIC - Static route set on the web app only

            These values will be used for syncing a Web App's routes with those from a Virtual Network. This operation will clear all DEFAULT and INHERITED routes and replace them
            with new INHERITED routes. |


<a id="VirtualDirectory" />
### VirtualDirectory object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  virtualPath | string | No |  |
|  physicalPath | string | No |  |


<a id="RampUpRule" />
### RampUpRule object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  actionHostName | string | No | Hostname of a slot to which the traffic will be redirected if decided to. E.g. mysite-stage.azurewebsites.net |
|  reroutePercentage | number | No | Percentage of the traffic which will be redirected to {Microsoft.Web.Hosting.Administration.RampUpRule.ActionHostName} |
|  changeStep | number | No | [Optional] In auto ramp up scenario this is the step to to add/remove from {Microsoft.Web.Hosting.Administration.RampUpRule.ReroutePercentage} until it reaches
            {Microsoft.Web.Hosting.Administration.RampUpRule.MinReroutePercentage} or {Microsoft.Web.Hosting.Administration.RampUpRule.MaxReroutePercentage}. Site metrics are checked every N minutes specificed in {Microsoft.Web.Hosting.Administration.RampUpRule.ChangeIntervalInMinutes}.
            Custom decision algorithm can be provided in TiPCallback site extension which Url can be specified in {Microsoft.Web.Hosting.Administration.RampUpRule.ChangeDecisionCallbackUrl} |
|  changeIntervalInMinutes | integer | No | [Optional] Specifies interval in mimuntes to reevaluate ReroutePercentage |
|  minReroutePercentage | number | No | [Optional] Specifies lower boundary above which ReroutePercentage will stay. |
|  maxReroutePercentage | number | No | [Optional] Specifies upper boundary below which ReroutePercentage will stay. |
|  changeDecisionCallbackUrl | string | No | Custom decision algorithm can be provided in TiPCallback site extension which Url can be specified. See TiPCallback site extension for the scaffold and contracts.
            https://www.siteextensions.net/packages/TiPCallback/ |
|  name | string | No | Name of the routing rule. The recommended name would be to point to the slot which will receive the traffic in the experiment. |


<a id="AutoHealTriggers" />
### AutoHealTriggers object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  requests | object | No | Requests - Defines a rule based on total requests - [RequestsBasedTrigger object](#RequestsBasedTrigger) |
|  privateBytesInKB | integer | No | PrivateBytesInKB - Defines a rule based on private bytes |
|  statusCodes | array | No | StatusCodes - Defines a rule based on status codes - [StatusCodesBasedTrigger object](#StatusCodesBasedTrigger) |
|  slowRequests | object | No | SlowRequests - Defines a rule based on request execution time - [SlowRequestsBasedTrigger object](#SlowRequestsBasedTrigger) |


<a id="AutoHealActions" />
### AutoHealActions object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  actionType | enum | Yes | ActionType - predefined action to be taken. - Recycle, LogEvent, CustomAction |
|  customAction | object | No | CustomAction - custom action to be taken - [AutoHealCustomAction object](#AutoHealCustomAction) |
|  minProcessExecutionTime | string | No | MinProcessExecutionTime - minimum time the process must execute
            before taking the action |


<a id="RequestsBasedTrigger" />
### RequestsBasedTrigger object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  count | integer | No | Count |
|  timeInterval | string | No | TimeInterval |


<a id="StatusCodesBasedTrigger" />
### StatusCodesBasedTrigger object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  status | integer | No | HTTP status code |
|  subStatus | integer | No | SubStatus |
|  win32Status | integer | No | Win32 error code |
|  count | integer | No | Count |
|  timeInterval | string | No | TimeInterval |


<a id="SlowRequestsBasedTrigger" />
### SlowRequestsBasedTrigger object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  timeTaken | string | No | TimeTaken |
|  count | integer | No | Count |
|  timeInterval | string | No | TimeInterval |


<a id="AutoHealCustomAction" />
### AutoHealCustomAction object
|  Name | Type | Required | Value |
|  ---- | ---- | ---- | ---- |
|  exe | string | No | Executable to be run |
|  parameters | string | No | Parameters for the executable |

