// FIXME: Operations in this file are not detected as a resource operation, please confirm the conversion result manually

import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.ResourceManager;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ApiExportOperations {
  /**
   * Gets the details of the API specified by its identifier in the format specified to the Storage Blob with SAS Key valid for 5 minutes.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiExport_Get")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/apis/{apiId}")
  @get
  get(
    ...ApiVersionParameter,
    ...ResourceGroupParameter,

    /**
     * The name of the API Management service.
     */
    @maxLength(50)
    @minLength(1)
    @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
    @path
    serviceName: string,

    /**
     * API revision identifier. Must be unique in the current API Management service instance. Non-current revision has ;rev=n as a suffix where n is the revision number.
     */
    @maxLength(256)
    @minLength(1)
    @pattern("^[^*#&+:<>?]+$")
    @path
    apiId: string,

    /**
     * Format in which to export the Api Details to the Storage Blob with Sas Key valid for 5 minutes.
     */
    @query("format")
    format: ExportFormat,

    /**
     * Query parameter required to export the API details.
     */
    @query("export")
    export: ExportApi,

    ...SubscriptionIdParameter,
  ): ArmResponse<ApiExportResult> | ErrorResponse;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface DeletedServicesOperations {
  /**
   * Lists all soft-deleted services available for undelete for the given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DeletedServices_ListBySubscription")
  @autoRoute
  @get
  @action("deletedservices")
  listBySubscription is ArmProviderActionSync<
    Response = ResourceListResult<DeletedServiceContract>,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ApiManagementServiceOperations {
  /**
   * Checks availability and correctness of a name for an API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_CheckNameAvailability")
  @autoRoute
  checkNameAvailability is ArmProviderActionSync<
    Request = ApiManagementServiceCheckNameAvailabilityParameters,
    Response = ApiManagementServiceNameAvailabilityResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
  /**
   * Get the custom domain ownership identifier for an API Management service.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementService_GetDomainOwnershipIdentifier")
  @autoRoute
  getDomainOwnershipIdentifier is ArmProviderActionSync<
    Response = ApiManagementServiceGetDomainOwnershipIdentifierResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-interface-requires-decorator" "For backward compatibility"
interface ApiManagementSkusOperations {
  /**
   * Gets the list of Microsoft.ApiManagement SKUs available for your Subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiManagementSkus_List")
  @autoRoute
  @get
  @action("skus")
  list is ArmProviderActionSync<
    Response = ApiManagementSkusResult,
    Scope = SubscriptionActionScope,
    Parameters = {}
  >;
}
