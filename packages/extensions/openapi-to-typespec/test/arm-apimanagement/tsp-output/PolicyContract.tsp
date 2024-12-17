import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Policy Contract details.
 */
@parentResource(OperationContract)
model PolicyContract
  is Azure.ResourceManager.ProxyResource<PolicyContractProperties> {
  ...ResourceNameParameter<
    Resource = PolicyContract,
    KeyName = "policyId",
    SegmentName = "policies",
    NamePattern = "",
    Type = PolicyIdName
  >;
}

@armResourceOperations
interface PolicyContracts {
  /**
   * Get the policy configuration at the API Operation level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_Get")
  get is ArmResourceRead<
    PolicyContract,
    Parameters = {
      /**
       * Policy Export Format.
       */
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  /**
   * Gets the entity state (Etag) version of the API operation policy specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<PolicyContract>;

  /**
   * Creates or updates policy configuration for the API Operation level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Deletes the policy configuration at the Api Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_Delete")
  delete is ArmResourceDeleteSync<
    PolicyContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Get the list of policy configuration at the API Operation level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiOperationPolicy_ListByOperation")
  listByOperation is ArmResourceListByParent<PolicyContract>;
}

@@doc(PolicyContract.name, "The identifier of the Policy.");
@@doc(PolicyContract.properties, "Properties of the Policy.");
@@doc(PolicyContracts.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
