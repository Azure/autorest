import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("A single API Management service resource in List or Get response.")
model ApiManagementServiceResource
  is TrackedResource<ApiManagementServiceProperties> {
  @doc("The name of the API Management service.")
  @maxLength(50)
  @minLength(1)
  @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
  @path
  @key("serviceName")
  @segment("service")
  name: string;

  @doc("ETag of the resource.")
  @visibility("read")
  etag?: string;

  @doc("A list of availability zones denoting where the resource needs to come from.")
  zones?: string[];

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface ApiManagementService {
  @doc("Gets an API Management service resource description.")
  get is ArmResourceRead<ApiManagementServiceResource>;
  @doc("Creates or updates an API Management service. This is long running operation and could take several minutes to complete.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ApiManagementServiceResource>;
  @doc("Updates an existing API Management service.")
  update is ArmCustomPatchAsync<
    ApiManagementServiceResource,
    ApiManagementServiceUpdateParameters
  >;
  @doc("Deletes an existing API Management service.")
  delete is ArmResourceDeleteAsync<ApiManagementServiceResource>;
  @doc("List all API Management services within a resource group.")
  listByResourceGroup is ArmResourceListByParent<ApiManagementServiceResource>;
  @doc("Lists all API Management services within an Azure subscription.")
  list is ArmListBySubscription<ApiManagementServiceResource>;
  @doc("Restores a backup of an API Management service created using the ApiManagementService_Backup operation on the current service. This is a long running operation and could take several minutes to complete.")
  restore is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ApiManagementServiceBackupRestoreParameters,
    ApiManagementServiceResource
  >;
  @doc("Creates a backup of the API Management service to the given Azure Storage Account. This is long running operation and could take several minutes to complete.")
  backup is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ApiManagementServiceBackupRestoreParameters,
    ApiManagementServiceResource
  >;
  @doc("Gets the Single-Sign-On token for the API Management Service which is valid for 5 Minutes.")
  getSsoToken is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ApiManagementServiceGetSsoTokenResult
  >;
  @doc("Updates the Microsoft.ApiManagement resource running in the Virtual network to pick the updated DNS changes.")
  applyNetworkConfigurationUpdates is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ApiManagementServiceApplyNetworkConfigurationParameters,
    ApiManagementServiceResource
  >;
}

@armResourceOperations
interface ApiManagementServices {
  @doc("Performs a connectivity check between the API Management service and a given destination, and returns metrics for the connection, as well as errors encountered while trying to establish it.")
  performConnectivityCheckAsync is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ConnectivityCheckRequest,
    ConnectivityCheckResponse
  >;
}

@armResourceOperations
interface TenantConfiguration {
  @doc("This operation applies changes from the specified Git branch to the configuration database. This is a long running operation and could take several minutes to complete.")
  deploy is ArmResourceActionAsync<
    ApiManagementServiceResource,
    DeployConfigurationParameters,
    OperationResultContract,
    {
      ...BaseParameters<ApiManagementServiceResource>;

      @doc("The identifier of the Git Configuration Operation.")
      @path
      configurationName: ConfigurationIdName;
    }
  >;
  @doc("This operation creates a commit with the current configuration snapshot to the specified branch in the repository. This is a long running operation and could take several minutes to complete.")
  save is ArmResourceActionAsync<
    ApiManagementServiceResource,
    SaveConfigurationParameter,
    OperationResultContract,
    {
      ...BaseParameters<ApiManagementServiceResource>;

      @doc("The identifier of the Git Configuration Operation.")
      @path
      configurationName: ConfigurationIdName;
    }
  >;
  @doc("This operation validates the changes in the specified Git branch. This is a long running operation and could take several minutes to complete.")
  validate is ArmResourceActionAsync<
    ApiManagementServiceResource,
    DeployConfigurationParameters,
    OperationResultContract,
    {
      ...BaseParameters<ApiManagementServiceResource>;

      @doc("The identifier of the Git Configuration Operation.")
      @path
      configurationName: ConfigurationIdName;
    }
  >;
  @doc("Gets the status of the most recent synchronization between the configuration database and the Git repository.")
  // FIXME: TenantConfiguration_GetSyncState could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tenant/{configurationName}/syncState")
  @get
  GetSyncState is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The identifier of the Git Configuration Operation.")
      @path
      configurationName: ConfigurationIdName;
    },
    TenantConfigurationSyncStateContract
  >;
}

@armResourceOperations
interface Api {
  @doc("Lists a collection of apis associated with tags.")
  // FIXME: Api_ListByTags could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apisByTags")
  @get
  ListByTags is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| isCurrent | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Include not tagged APIs.")
      @query("includeNotTaggedApis")
      includeNotTaggedApis?: boolean;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagResourceListResult
  >;
}

@armResourceOperations
interface ContentType {
  @doc("Lists the developer portal's content types. Content types describe content items' properties, validation rules, and constraints.")
  // FIXME: ContentType_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/contentTypes")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ContentTypeListResult
  >;

  @doc("Gets the details of the developer portal's content type. Content types describe content items' properties, validation rules, and constraints.")
  // FIXME: ContentType_Get could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/contentTypes/{contentTypeId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Content type identifier.")
      @maxLength(80)
      @minLength(1)
      @path
      contentTypeId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ContentTypeContract
  >;
}

@armResourceOperations
interface ContentItem {
  @doc("Lists developer portal's content items specified by the provided content type.")
  // FIXME: ContentItem_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/contentTypes/{contentTypeId}/contentItems")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Content type identifier.")
      @maxLength(80)
      @minLength(1)
      @path
      contentTypeId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ContentItemListResult
  >;

  @doc("Returns the developer portal's content item specified by its identifier.")
  // FIXME: ContentItem_Get could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/contentTypes/{contentTypeId}/contentItems/{contentItemId}")
  @get
  Get is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Content type identifier.")
      @maxLength(80)
      @minLength(1)
      @path
      contentTypeId: string;

      @doc("Content item identifier.")
      @maxLength(80)
      @minLength(1)
      @path
      contentItemId: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ContentItemContract
  >;
}

@armResourceOperations
interface ApiManagementServiceSkus {
  @summary("Gets available SKUs for API Management service")
  @doc("Gets all available SKU for a given API Management service")
  // FIXME: ApiManagementServiceSkus_ListAvailableServiceSkus could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/skus")
  @get
  ListAvailableServiceSkus is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ResourceSkuResults
  >;
}

@armResourceOperations
interface NetworkStatus {
  @doc("Gets the Connectivity Status to the external resources on which the Api Management service depends from inside the Cloud Service. This also returns the DNS Servers as visible to the CloudService.")
  // FIXME: NetworkStatus_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/networkstatus")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;
    },
    void
  >;

  @doc("Gets the Connectivity Status to the external resources on which the Api Management service depends from inside the Cloud Service. This also returns the DNS Servers as visible to the CloudService.")
  // FIXME: NetworkStatus_ListByLocation could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/locations/{locationName}/networkstatus")
  @get
  ListByLocation is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Location in which the API Management service is deployed. This is one of the Azure Regions like West US, East US, South Central US.")
      @minLength(1)
      @path
      locationName: string;
    },
    NetworkStatusContract
  >;
}

@armResourceOperations
interface OutboundNetworkDependenciesEndpoints {
  @doc("Gets the network endpoints of all outbound dependencies of a ApiManagement service.")
  // FIXME: OutboundNetworkDependenciesEndpoints_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/outboundNetworkDependenciesEndpoints")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;

      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;
    },
    OutboundEnvironmentEndpointList
  >;
}

@armResourceOperations
interface PolicyDescription {
  @doc("Lists all policy descriptions.")
  // FIXME: PolicyDescription_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/policyDescriptions")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Policy scope.")
      @query("scope")
      scope?: PolicyScopeContract;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    PolicyDescriptionListResult
  >;
}

@armResourceOperations
interface PortalSettings {
  @doc("Lists a collection of portalsettings defined within a service instance..")
  // FIXME: PortalSettings_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/portalsettings")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    PortalSettingsListResult
  >;
}

@armResourceOperations
interface Product {
  @doc("Lists a collection of products associated with tags.")
  // FIXME: Product_ListByTags could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/productsByTags")
  @get
  ListByTags is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| terms | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Include not tagged Products.")
      @query("includeNotTaggedProducts")
      includeNotTaggedProducts?: boolean;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagResourceListResult
  >;
}

@armResourceOperations
interface QuotaByCounterKeys {
  @doc("Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.")
  // FIXME: QuotaByCounterKeys_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/quotas/{quotaCounterKey}")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key=\"boo\" in the policy, then it’s accessible by \"boo\" counter key. But if it’s defined as counter-key=\"@(\"b\"+\"a\")\" then it will be accessible by \"ba\" key")
      @path
      quotaCounterKey: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    QuotaCounterListResult
  >;
}

@armResourceOperations
interface QuotaByPeriodKeys {
  @doc("Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.")
  // FIXME: QuotaByPeriodKeys_Get could not be converted to a resource operation
  Get is Azure.Core.ResourceRead<QuotaCounterContract>;
}

@armResourceOperations
interface Region {
  @doc("Lists all azure regions in which the service exists.")
  // FIXME: Region_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/regions")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    RegionListResult
  >;
}

@armResourceOperations
interface Reports {
  @doc("Lists report records by API.")
  // FIXME: Reports_ListByApi could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byApi")
  @get
  ListByApi is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("The filter to apply on the operation.")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by User.")
  // FIXME: Reports_ListByUser could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byUser")
  @get
  ListByUser is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| userId | select, filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by API Operations.")
  // FIXME: Reports_ListByOperation could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byOperation")
  @get
  ListByOperation is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by Product.")
  // FIXME: Reports_ListByProduct could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byProduct")
  @get
  ListByProduct is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by geography.")
  // FIXME: Reports_ListByGeo could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byGeo")
  @get
  ListByGeo is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| country | select |     |     | </br>| region | select |     |     | </br>| zip | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by subscription.")
  // FIXME: Reports_ListBySubscription could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/bySubscription")
  @get
  ListBySubscription is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | select, filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by Time.")
  // FIXME: Reports_ListByTime could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byTime")
  @get
  ListByTime is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter, select | ge, le |     | </br>| interval | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("OData order by query option.")
      @query("$orderby")
      orderBy?: string;

      @doc("By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds)).")
      @query("interval")
      interval: duration;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ReportListResult
  >;

  @doc("Lists report records by Request.")
  // FIXME: Reports_ListByRequest could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/reports/byRequest")
  @get
  ListByRequest is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| productId | filter | eq |     | </br>| userId | filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>")
      @query("$filter")
      $filter: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    RequestReportListResult
  >;
}

@armResourceOperations
interface TagResource {
  @doc("Lists a collection of resources associated with tags.")
  // FIXME: TagResource_ListByService could not be converted to a resource operation
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/tagResources")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| aid | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| terms | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| isCurrent | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    TagResourceListResult
  >;
}
