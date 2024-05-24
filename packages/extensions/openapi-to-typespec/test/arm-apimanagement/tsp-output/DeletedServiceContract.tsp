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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  DeletedServiceContractProperties
)
model DeletedServiceContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DeletedServiceContract,
    KeyName = "serviceName",
    SegmentName = "deletedservices",
    NamePattern = "^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$"
  >;

  /**
   * Deleted API Management Service details.
   */
  @extension("x-ms-client-flatten", true)
  properties?: DeletedServiceContractProperties;
}

@armResourceOperations
interface DeletedServiceContracts {
  /**
   * Get soft-deleted Api Management Service by name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DeletedServices_GetByName")
  getByName is ArmResourceRead<DeletedServiceContract>;

  /**
   * Purges Api Management Service (deletes it with no option to undelete).
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("DeletedServices_Purge")
  purge is ArmResourceDeleteAsync<DeletedServiceContract>;

  /**
   * Lists all soft-deleted services available for undelete for the given subscription.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DeletedServices_ListBySubscription")
  listBySubscription is ArmListBySubscription<DeletedServiceContract>;
}

@@maxLength(DeletedServiceContract.name, 50);
@@minLength(DeletedServiceContract.name, 1);
@@doc(DeletedServiceContract.name, "The name of the API Management service.");
