import "@typespec/http";
import "@typespec/rest";
import "@typespec/versioning";
import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";

using TypeSpec.Http;
using TypeSpec.Rest;
using TypeSpec.Versioning;
using Azure.Core;
using Azure.ResourceManager;

namespace Azure.ResourceManager.Legacy {
  interface LegacyOperations<
    ParentParameters extends {},
    ResourceTypeParameter extends {},
    ErrorType extends {} = ErrorResponse
  > {
    /**
     * @dev A long-running resource CreateOrUpdate (PUT)
     * @template Resource the resource being created or updated
     * @template LroHeaders Optional.  Allows overriding the lro headers returned on resource create
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the PUT operation
     */
    #suppress "@azure-tools/typespec-azure-core/no-private-usage"
    @autoRoute
    @doc("Create a {name}", Resource)
    @armResourceCreateOrUpdate(Resource)
    @Azure.Core.Foundations.Private.defaultFinalStateVia(#[
      "location",
      "azure-async-operation"
    ])
    @put
    CreateOrUpdateAsync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      LroHeaders extends TypeSpec.Reflection.Model = ArmAsyncOperationHeader<FinalResult = Resource> &
        Azure.Core.Foundations.RetryAfterHeader,
      Parameters extends {} = {},
      Response extends {} = ArmResourceUpdatedResponse<Resource> | ArmResourceCreatedResponse<
        Resource,
        LroHeaders
      >
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
      @doc("Resource create parameters.") @bodyRoot resource: Resource,
    ): Response | ErrorType;

    /**
     * @dev A synchronous resource CreateOrUpdate (PUT)
     * @template Resource the resource being created or updated
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the PUT operation
     */
    #suppress "@azure-tools/typespec-azure-core/no-private-usage"
    @autoRoute
    @doc("Create a {name}", Resource)
    @armResourceCreateOrUpdate(Resource)
    @put
    CreateOrUpdateSync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmResourceUpdatedResponse<Resource> | ArmResourceCreatedSyncResponse<Resource>
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
      @doc("Resource create parameters.") @bodyRoot resource: Resource,
    ): Response | ErrorType;

    /**
     * @dev A long-running resource Update (PATCH)
     * @template Resource the resource being created or updated
     * @template PatchModel the PATCH request model
     * @template LroHeaders Optional.  Allows overriding the lro headers returned on resource create
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the PATCH operation
     */
    @autoRoute
    @doc("Update a {name}", Resource)
    @armResourceUpdate(Resource)
    @patch
    CustomPatchAsync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      PatchModel extends {} = Azure.ResourceManager.Foundations.TagsUpdateModel<Resource>,
      LroHeaders extends TypeSpec.Reflection.Model = ArmLroLocationHeader<
        Azure.Core.StatusMonitorPollingOptions<ArmOperationStatus>,
        Resource,
        string
      > &
        Azure.Core.Foundations.RetryAfterHeader,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<Resource> | ArmAcceptedLroResponse<
        "Resource update request accepted.",
        LroHeaders
      >
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
      @doc("Resource create parameters.") @bodyRoot properties: PatchModel,
    ): Response | ErrorType;

    /**
     * @dev A synchronous resource Update (PATCH)
     * @template Resource the resource being created or updated
     * @template PatchModel the PATCH request model
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the PATCH operation
     */
    @autoRoute
    @doc("Update a {name}", Resource)
    @armResourceUpdate(Resource)
    @patch
    CustomPatchSync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      PatchModel extends {} = Azure.ResourceManager.Foundations.TagsUpdateModel<Resource>,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<Resource>
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
      @doc("Resource create parameters.") @bodyRoot properties: PatchModel,
    ): Response | ErrorType;

    /**
     * @dev Delete a resource asynchronously
     * @template Resource The resource being deleted
     * @template LroHeaders The lro headers for the operation
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the delete operation
     */
    #suppress "@azure-tools/typespec-azure-core/no-response-body" "Valid"
    @autoRoute
    @doc("Delete a {name}", Resource)
    @delete
    @deletesResource(Resource)
    @armResourceDelete(Resource)
    DeleteWithoutOkAsync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      LroHeaders extends TypeSpec.Reflection.Model = ArmLroLocationHeader &
        Azure.Core.Foundations.RetryAfterHeader,
      Parameters extends {} = {},
      Response extends {} = ArmDeletedResponse | ArmDeleteAcceptedLroResponse<LroHeaders> | ArmDeletedNoContentResponse
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
    ): Response | ErrorType;

    /**
     * @dev Delete a resource synchronously
     * @template Resource The resource being deleted
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response(s) for the delete operation
     */
    #suppress "@azure-tools/typespec-azure-core/no-response-body" "Valid"
    @autoRoute
    @doc("Delete a {name}", Resource)
    @delete
    @deletesResource(Resource)
    @armResourceDelete(Resource)
    DeleteSync<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmDeletedResponse | ArmDeletedNoContentResponse
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
    ): Response | ErrorType;

    /**
     * @dev Get a resource
     * @template Resource The resource being read
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response for a get operation.
     */
    @autoRoute
    @doc("Get a {name}", Resource)
    @get
    @readsResource(Resource)
    @armResourceRead(Resource)
    Read<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<Resource>
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
    ): Response | ErrorType;

    /**
     * @dev Get a resource
     * @template Resource The resource being read
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The success response for a get operation.
     */
    @doc("Get a {name}", Resource)
    @get
    @readsResource(Resource)
    @armResourceRead(Resource)
    ReadRoute<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<Resource>
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,
    ): Response | ErrorType;

    /**
     * @dev List a resource
     * @template Resource The resource being listed
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The response returned by the list
     */
    @autoRoute
    @doc("List {name} resources", Resource)
    @get
    @listsResource(Resource)
    @segmentOf(Resource)
    @armResourceList(Resource)
    List<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<ResourceListResult<Resource>>
    >(...ParentParameters, ...Parameters): Response | ErrorType;

    /**
     * @dev List a resource
     * @template Resource The resource being listed
     * @template Parameters Optional. Additional parameters after the path parameters
     * @template Response Optional. The response returned by the list
     */
    @doc("List {name} resources", Resource)
    @get
    @listsResource(Resource)
    @armResourceList(Resource)
    ListRoute<
      Resource extends Azure.ResourceManager.CommonTypes.Resource,
      Parameters extends {} = {},
      Response extends {} = ArmResponse<ResourceListResult<Resource>>
    >(...ParentParameters, ...Parameters): Response | ErrorType;

    /**
     * A synchronous resource action.
     * @template Resource The resource being acted upon
     * @template Request The request model for the action
     * @template Response The response model for the action
     * @template Parameters Optional. Additional parameters after the path parameters
     */
    #suppress "@azure-tools/typespec-azure-core/no-private-usage"
    @autoRoute
    @armResourceAction(Resource)
    @Private.enforceConstraint(Resource, Foundations.Resource)
    @post
    @returnsDoc("Azure operation completed successfully.")
    ActionSync<
      Resource extends Foundations.Resource,
      Request extends TypeSpec.Reflection.Model | void,
      Response extends TypeSpec.Reflection.Model | void,
      Parameters extends {} = {}
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,

      @doc("The content of the action request")
      @bodyRoot
      body: Request,
    ): Response | ErrorType;

    /**
     * A long-running resource action.
     * @template Resource The resource being acted upon
     * @template Request The request model for the action
     * @template LroHeaders Optional. Allows overriding the headers returned in the Accepted response
     * @template Response The response model for the action
     * @template Parameters Optional. Additional parameters after the path parameters
     */
    #suppress "@azure-tools/typespec-azure-core/no-response-body" "ARM"
    #suppress "@azure-tools/typespec-azure-core/no-private-usage" "template"
    @autoRoute
    @armResourceAction(Resource)
    @Private.enforceConstraint(Resource, Foundations.Resource)
    @post
    @returnsDoc("Azure operation completed successfully.")
    ActionAsync<
      Resource extends Foundations.Resource,
      Request extends TypeSpec.Reflection.Model | void,
      Result extends TypeSpec.Reflection.Model | void,
      LroHeaders extends TypeSpec.Reflection.Model = ArmLroLocationHeader<
        Azure.Core.StatusMonitorPollingOptions<ArmOperationStatus>,
        Result,
        string
      > &
        Azure.Core.Foundations.RetryAfterHeader,
      Parameters extends {} = {},
      Response extends {} | void = ArmAcceptedLroResponse<
        "Resource operation accepted.",
        LroHeaders
      > | Result
    >(
      ...ParentParameters,
      ...ResourceTypeParameter,
      ...Parameters,

      @doc("The content of the action request")
      @bodyRoot
      body: Request,
    ): Response | ErrorType;
  }
  /**
   * @dev Get the provider namespace key-value pair
   * @template Resource Optional.  The resource to get the provider namespace for.
   */
  model Provider<Resource extends {} = TenantActionScope> {
    ...ProviderNamespace<Resource>;
  }
}
