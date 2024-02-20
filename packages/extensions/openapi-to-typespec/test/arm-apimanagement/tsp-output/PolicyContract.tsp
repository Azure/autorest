import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Policy Contract details.
 */
@parentResource(OperationContract)
model PolicyContract is ProxyResource<PolicyContractProperties> {
  /**
   * The identifier of the Policy.
   */
  @path
  @key("policyId")
  @segment("policies")
  @visibility("read")
  name: PolicyIdName;
}

@armResourceOperations
interface PolicyContracts {
  /**
   * Get the policy configuration at the API Operation level.
   */
  get is ArmResourceRead<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

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
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PolicyContract,
      BaseParameters<PolicyContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates policy configuration for the API Operation level.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

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
  delete is ArmResourceDeleteSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

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
  listByOperation is ArmResourceListByParent<PolicyContract>;
}

@@doc(PolicyContracts.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
