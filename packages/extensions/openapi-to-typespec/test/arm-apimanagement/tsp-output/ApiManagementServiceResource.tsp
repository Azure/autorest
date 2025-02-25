import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * A single API Management service resource in List or Get response.
 */
model ApiManagementServiceResource
  is Azure.ResourceManager.TrackedResource<
    ApiManagementServiceProperties,
    false
  > {
  ...ResourceNameParameter<
    Resource = ApiManagementServiceResource,
    KeyName = "serviceName",
    SegmentName = "service",
    NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;

  /**
   * SKU properties of the API Management service.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  sku: ApiManagementServiceSkuProperties;

  /**
   * Managed service identity of the Api Management service.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  identity?: ApiManagementServiceIdentity;

  ...Azure.ResourceManager.EntityTagProperty;
  ...Azure.ResourceManager.AvailabilityZonesProperty;
}

@armResourceOperations
interface ApiManagementServiceResources {
  /**
   * Gets an API Management service resource description.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_Get")
  get is ArmResourceRead<ApiManagementServiceResource>;

  /**
   * Creates or updates an API Management service. This is long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("ApiManagementService_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    ApiManagementServiceResource,
    Response = ArmResourceUpdatedResponse<ApiManagementServiceResource> | ArmResourceCreatedResponse<
      ApiManagementServiceResource,
      ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader
    > | ArmAcceptedLroResponse
  >;

  /**
   * Updates an existing API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("ApiManagementService_Update")
  update is ArmCustomPatchAsync<
    ApiManagementServiceResource,
    PatchModel = ApiManagementServiceUpdateParameters
  >;

  /**
   * Deletes an existing API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/no-response-body" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("ApiManagementService_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    ApiManagementServiceResource,
    Response = ArmDeletedResponse | (ArmDeleteAcceptedLroResponse & {
      @bodyRoot
      _: ApiManagementServiceResource;
    }) | ArmDeletedNoContentResponse
  >;

  /**
   * List all API Management services within a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_ListByResourceGroup")
  listByResourceGroup is ArmResourceListByParent<ApiManagementServiceResource>;

  /**
   * Lists all API Management services within an Azure subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_List")
  list is ArmListBySubscription<ApiManagementServiceResource>;

  /**
   * Lists a collection of apis associated with tags.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("apisByTags")
  @operationId("Api_ListByTags")
  listByTags is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<TagResourceListResult>,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| isCurrent | filter | eq |     |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * Include not tagged APIs.
       */
      @query("includeNotTaggedApis")
      includeNotTaggedApis?: boolean;
    }
  >;

  /**
   * Performs a connectivity check between the API Management service and a given destination, and returns metrics for the connection, as well as errors encountered while trying to establish it.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("connectivityCheck")
  @operationId("PerformConnectivityCheckAsync")
  performConnectivityCheckAsync is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ConnectivityCheckRequest,
    ArmResponse<ConnectivityCheckResponse>
  >;

  /**
   * Gets all available SKU for a given API Management service
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("skus")
  @operationId("ApiManagementServiceSkus_ListAvailableServiceSkus")
  listAvailableServiceSkus is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ResourceSkuResults>
  >;

  /**
   * Restores a backup of an API Management service created using the ApiManagementService_Backup operation on the current service. This is a long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_Restore")
  restore is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ApiManagementServiceBackupRestoreParameters,
    ArmResponse<ApiManagementServiceResource>
  >;

  /**
   * Creates a backup of the API Management service to the given Azure Storage Account. This is long running operation and could take several minutes to complete.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_Backup")
  backup is ArmResourceActionAsync<
    ApiManagementServiceResource,
    ApiManagementServiceBackupRestoreParameters,
    ArmResponse<ApiManagementServiceResource>
  >;

  /**
   * Gets the Single-Sign-On token for the API Management Service which is valid for 5 Minutes.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("getssotoken")
  @operationId("ApiManagementService_GetSsoToken")
  getSsoToken is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ApiManagementServiceGetSsoTokenResult>
  >;

  /**
   * Updates the Microsoft.ApiManagement resource running in the Virtual network to pick the updated DNS changes.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("applynetworkconfigurationupdates")
  @operationId("ApiManagementService_ApplyNetworkConfigurationUpdates")
  applyNetworkConfigurationUpdates is ArmResourceActionAsync<
    ApiManagementServiceResource,
    {
      /**
       * Parameters supplied to the Apply Network Configuration operation. If the parameters are empty, all the regions in which the Api Management service is deployed will be updated sequentially without incurring downtime in the region.
       */
      @bodyRoot
      parameters?: ApiManagementServiceApplyNetworkConfigurationParameters;
    },
    ArmResponse<ApiManagementServiceResource>
  >;

  /**
   * Gets the Connectivity Status to the external resources on which the Api Management service depends from inside the Cloud Service. This also returns the DNS Servers as visible to the CloudService.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("networkstatus")
  @operationId("NetworkStatus_ListByService")
  listByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<Azure.Core.Page<NetworkStatusContractByLocation>>
  >;

  /**
   * Gets the Connectivity Status to the external resources on which the Api Management service depends from inside the Cloud Service. This also returns the DNS Servers as visible to the CloudService.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("networkstatus")
  @operationId("NetworkStatus_ListByLocation")
  listByLocation is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<NetworkStatusContract>,
    Parameters = {
      /**
       * Location in which the API Management service is deployed. This is one of the Azure Regions like West US, East US, South Central US.
       */
      @minLength(1)
      @path
      locationName: string;
    }
  >;

  /**
   * Gets the network endpoints of all outbound dependencies of a ApiManagement service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("outboundNetworkDependenciesEndpoints")
  @operationId("OutboundNetworkDependenciesEndpoints_ListByService")
  outboundNetworkDependenciesEndpointsListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<OutboundEnvironmentEndpointList>
  >;

  /**
   * Lists all policy descriptions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("policyDescriptions")
  @operationId("PolicyDescription_ListByService")
  policyDescriptionListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<PolicyDescriptionListResult>,
    Parameters = {
      /**
       * Policy scope.
       */
      @query("scope")
      scope?: PolicyScopeContract;
    }
  >;

  /**
   * Lists a collection of portalsettings defined within a service instance..
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("portalsettings")
  @operationId("PortalSettings_ListByService")
  portalSettingsListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<PortalSettingsListResult>
  >;

  /**
   * Lists a collection of products associated with tags.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("productsByTags")
  @operationId("Product_ListByTags")
  productListByTags is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<TagResourceListResult>,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| terms | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * Include not tagged Products.
       */
      @query("includeNotTaggedProducts")
      includeNotTaggedProducts?: boolean;
    }
  >;

  /**
   * Lists a collection of current quota counter periods associated with the counter-key configured in the policy on the specified service instance. The api does not support paging yet.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("{quotaCounterKey}")
  @operationId("QuotaByCounterKeys_ListByService")
  quotaByCounterKeysListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<QuotaCounterListResult>,
    Parameters = {
      @doc("Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key=\"boo\" in the policy, then it’s accessible by \"boo\" counter key. But if it’s defined as counter-key=\"@(\"b\"+\"a\")\" then it will be accessible by \"ba\" key")
      @path
      quotaCounterKey: string;
    }
  >;

  /**
   * Updates all the quota counter values specified with the existing quota counter key to a value in the specified service instance. This should be used for reset of the quota counter values.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch
  @action("{quotaCounterKey}")
  @operationId("QuotaByCounterKeys_Update")
  quotaByCounterKeysUpdate is ArmResourceActionSync<
    ApiManagementServiceResource,
    QuotaCounterValueUpdateContract,
    ArmResponse<QuotaCounterListResult>,
    Parameters = {
      @doc("Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key=\"boo\" in the policy, then it’s accessible by \"boo\" counter key. But if it’s defined as counter-key=\"@(\"b\"+\"a\")\" then it will be accessible by \"ba\" key")
      @path
      quotaCounterKey: string;
    }
  >;

  /**
   * Gets the value of the quota counter associated with the counter-key in the policy for the specific period in service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("{quotaPeriodKey}")
  @operationId("QuotaByPeriodKeys_Get")
  quotaByPeriodKeysGet is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<QuotaCounterContract>,
    Parameters = {
      @doc("Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key=\"boo\" in the policy, then it’s accessible by \"boo\" counter key. But if it’s defined as counter-key=\"@(\"b\"+\"a\")\" then it will be accessible by \"ba\" key")
      @path
      quotaCounterKey: string;

      /**
       * Quota period key identifier.
       */
      @path
      quotaPeriodKey: string;
    }
  >;

  /**
   * Updates an existing quota counter value in the specified service instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @patch
  @action("{quotaPeriodKey}")
  @operationId("QuotaByPeriodKeys_Update")
  quotaByPeriodKeysUpdate is ArmResourceActionSync<
    ApiManagementServiceResource,
    QuotaCounterValueUpdateContract,
    ArmResponse<QuotaCounterContract>,
    Parameters = {
      @doc("Quota counter key identifier.This is the result of expression defined in counter-key attribute of the quota-by-key policy.For Example, if you specify counter-key=\"boo\" in the policy, then it’s accessible by \"boo\" counter key. But if it’s defined as counter-key=\"@(\"b\"+\"a\")\" then it will be accessible by \"ba\" key")
      @path
      quotaCounterKey: string;

      /**
       * Quota period key identifier.
       */
      @path
      quotaPeriodKey: string;
    }
  >;

  /**
   * Lists all azure regions in which the service exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("regions")
  @operationId("Region_ListByService")
  regionListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<RegionListResult>
  >;

  /**
   * Lists report records by API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byApi")
  @operationId("Reports_ListByApi")
  listByApi is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * The filter to apply on the operation.
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;
    }
  >;

  /**
   * Lists report records by User.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byUser")
  @operationId("Reports_ListByUser")
  listByUser is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| userId | select, filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;
    }
  >;

  /**
   * Lists report records by API Operations.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byOperation")
  @operationId("Reports_ListByOperation")
  listByOperation is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;
    }
  >;

  /**
   * Lists report records by Product.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byProduct")
  @operationId("Reports_ListByProduct")
  listByProduct is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;
    }
  >;

  /**
   * Lists report records by geography.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byGeo")
  @operationId("Reports_ListByGeo")
  listByGeo is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| country | select |     |     | </br>| region | select |     |     | </br>| zip | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;

  /**
   * Lists report records by subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("bySubscription")
  @operationId("Reports_ListBySubscription")
  listBySubscription is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| displayName | select, orderBy |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | select, filter | eq |     | </br>| productId | select, filter | eq |     | </br>| subscriptionId | select, filter | eq |     | </br>| callCountSuccess | select, orderBy |     |     | </br>| callCountBlocked | select, orderBy |     |     | </br>| callCountFailed | select, orderBy |     |     | </br>| callCountOther | select, orderBy |     |     | </br>| callCountTotal | select, orderBy |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select, orderBy |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;
    }
  >;

  /**
   * Lists report records by Time.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byTime")
  @operationId("Reports_ListByTime")
  listByTime is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<ReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter, select | ge, le |     | </br>| interval | select |     |     | </br>| apiRegion | filter | eq |     | </br>| userId | filter | eq |     | </br>| productId | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| callCountSuccess | select |     |     | </br>| callCountBlocked | select |     |     | </br>| callCountFailed | select |     |     | </br>| callCountOther | select |     |     | </br>| bandwidth | select, orderBy |     |     | </br>| cacheHitsCount | select |     |     | </br>| cacheMissCount | select |     |     | </br>| apiTimeAvg | select |     |     | </br>| apiTimeMin | select |     |     | </br>| apiTimeMax | select |     |     | </br>| serviceTimeAvg | select |     |     | </br>| serviceTimeMin | select |     |     | </br>| serviceTimeMax | select |     |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;

      /**
       * OData order by query option.
       */
      @query("$orderby")
      orderBy?: string;

      /**
       * By time interval. Interval must be multiple of 15 minutes and may not be zero. The value should be in ISO  8601 format (http://en.wikipedia.org/wiki/ISO_8601#Durations).This code can be used to convert TimeSpan to a valid interval string: XmlConvert.ToString(new TimeSpan(hours, minutes, seconds)).
       */
      @query("interval")
      interval: duration;
    }
  >;

  /**
   * Lists report records by Request.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("byRequest")
  @operationId("Reports_ListByRequest")
  listByRequest is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<RequestReportListResult>,
    Parameters = {
      /**
       * |   Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| timestamp | filter | ge, le |     | </br>| apiId | filter | eq |     | </br>| operationId | filter | eq |     | </br>| productId | filter | eq |     | </br>| userId | filter | eq |     | </br>| apiRegion | filter | eq |     | </br>| subscriptionId | filter | eq |     | </br>
       */
      @query("$filter")
      $filter: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;

  /**
   * Lists a collection of resources associated with tags.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @get
  @action("tagResources")
  @operationId("TagResource_ListByService")
  tagResourceListByService is ArmResourceActionSync<
    ApiManagementServiceResource,
    void,
    ArmResponse<TagResourceListResult>,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| aid | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| apiRevision | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| path | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| serviceUrl | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| method | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| urlTemplate | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| terms | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>| isCurrent | filter | eq |     |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}

@@maxLength(ApiManagementServiceResource.name, 50);
@@minLength(ApiManagementServiceResource.name, 1);
@@doc(ApiManagementServiceResource.name,
  "The name of the API Management service."
);
@@encodedName(ApiManagementServiceResource.eTag, "application/json", "etag");
@@doc(ApiManagementServiceResource.properties,
  "Properties of the API Management service."
);
@@doc(ApiManagementServiceResources.createOrUpdate::parameters.resource,
  "Parameters supplied to the CreateOrUpdate API Management service operation."
);
@@doc(ApiManagementServiceResources.update::parameters.properties,
  "Parameters supplied to the CreateOrUpdate API Management service operation."
);
@@doc(ApiManagementServiceResources.performConnectivityCheckAsync::parameters.body,
  "Connectivity Check request parameters."
);
@@doc(ApiManagementServiceResources.restore::parameters.body,
  "Parameters supplied to the Restore API Management service from backup operation."
);
@@doc(ApiManagementServiceResources.backup::parameters.body,
  "Parameters supplied to the ApiManagementService_Backup operation."
);
@@doc(ApiManagementServiceResources.quotaByCounterKeysUpdate::parameters.body,
  "The value of the quota counter to be applied to all quota counter periods."
);
@@doc(ApiManagementServiceResources.quotaByPeriodKeysUpdate::parameters.body,
  "The value of the Quota counter to be applied on the specified period."
);
