import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(Workspace)
model OnlineEndpointTrackedResource
  is Azure.ResourceManager.TrackedResource<OnlineEndpoint, false> {
  ...ResourceNameParameter<
    Resource = OnlineEndpointTrackedResource,
    KeyName = "endpointName",
    SegmentName = "onlineEndpoints",
    NamePattern = ""
  >;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface OnlineEndpointTrackedResources {
  /**
   * Get Online Endpoint.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineEndpoints_Get")
  get is ArmResourceRead<OnlineEndpointTrackedResource>;

  /**
   * Create or update Online Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineEndpoints_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<OnlineEndpointTrackedResource>;

  /**
   * Update Online Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("OnlineEndpoints_Update")
  update is ArmCustomPatchAsync<
    OnlineEndpointTrackedResource,
    PatchModel = PartialMinimalTrackedResourceWithIdentity
  >;

  /**
   * Delete Online Endpoint (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("OnlineEndpoints_Delete")
  delete is ArmResourceDeleteWithoutOkAsync<
    OnlineEndpointTrackedResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List Online Endpoints.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineEndpoints_List")
  list is ArmResourceListByParent<
    OnlineEndpointTrackedResource,
    Parameters = {
      /**
       * Name of the endpoint.
       */
      @query("name")
      name?: string;

      /**
       * Number of endpoints to be retrieved in a page of results.
       */
      @query("count")
      count?: int32;

      /**
       * EndpointComputeType to be filtered by.
       */
      @query("computeType")
      computeType?: EndpointComputeType;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * A set of tags with which to filter the returned models. It is a comma separated string of tags key or tags key=value. Example: tagKey1,tagKey2,tagKey3=value3 .
       */
      @query("tags")
      tags?: string;

      /**
       * A set of properties with which to filter the returned models. It is a comma separated string of properties key and/or properties key=value Example: propKey1,propKey2,propKey3=value3 .
       */
      @query("properties")
      properties?: string;

      /**
       * The option to order the response.
       */
      @query("orderBy")
      orderBy?: OrderString;
    },
    Response = ArmResponse<OnlineEndpointTrackedResourceArmPaginatedResult>
  >;

  /**
   * List EndpointAuthKeys for an Endpoint using Key-based authentication.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineEndpoints_ListKeys")
  listKeys is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    ArmResponse<EndpointAuthKeys>
  >;

  /**
   * Regenerate EndpointAuthKeys for an Endpoint using Key-based authentication (asynchronous).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("OnlineEndpoints_RegenerateKeys")
  regenerateKeys is ArmResourceActionAsync<
    OnlineEndpointTrackedResource,
    RegenerateEndpointKeysRequest,
    void
  >;

  /**
   * Retrieve a valid AML token for an Endpoint using AMLToken-based authentication.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @action("token")
  @operationId("OnlineEndpoints_GetToken")
  getToken is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    ArmResponse<EndpointAuthToken>
  >;
}

@@doc(OnlineEndpointTrackedResource.name, "Online Endpoint name.");
@@doc(OnlineEndpointTrackedResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "Online Endpoint entity to apply during operation."
);
@@doc(OnlineEndpointTrackedResources.update::parameters.properties,
  "Online Endpoint entity to apply during operation."
);
@@doc(OnlineEndpointTrackedResources.regenerateKeys::parameters.body,
  "RegenerateKeys request ."
);
