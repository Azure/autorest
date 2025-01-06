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
 * Deleted API Management Service information.
 */
@subscriptionResource
@parentResource(SubscriptionLocationResource)
model DeletedServiceContract
  is Azure.ResourceManager.ProxyResource<DeletedServiceContractProperties> {
  ...ResourceNameParameter<
    Resource = DeletedServiceContract,
    KeyName = "serviceName",
    SegmentName = "deletedservices",
    NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;

  /**
   * API Management Service Master Location.
   */
  @visibility("read")
  location?: string;
}

@armResourceOperations
interface DeletedServiceContracts {
  /**
   * Get soft-deleted Api Management Service by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("DeletedServices_GetByName")
  getByName is ArmResourceRead<
    DeletedServiceContract,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters
  >;

  /**
   * Purges Api Management Service (deletes it with no option to undelete).
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("DeletedServices_Purge")
  purge is ArmResourceDeleteWithoutOkAsync<
    DeletedServiceContract,
    BaseParameters = Azure.ResourceManager.Foundations.SubscriptionBaseParameters,
    Response = ArmDeletedResponse | (ArmDeleteAcceptedLroResponse & {
      @bodyRoot
      _: DeletedServiceContract;
    }) | ArmDeletedNoContentResponse
  >;
}

@@maxLength(DeletedServiceContract.name, 50);
@@minLength(DeletedServiceContract.name, 1);
@@doc(DeletedServiceContract.name, "The name of the API Management service.");
@@doc(DeletedServiceContract.properties,
  "Deleted API Management Service details."
);
