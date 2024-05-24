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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(OperationContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(PolicyContractProperties)
model PolicyContract extends Foundations.ProxyResource {
  /**
   * The identifier of the Policy.
   */
  @path
  @key("policyId")
  @segment("policies")
  @visibility("read")
  name: PolicyIdName;

  /**
   * Properties of the Policy.
   */
  @extension("x-ms-client-flatten", true)
  properties?: PolicyContractProperties;
}

@armResourceOperations
interface PolicyContracts {
  /**
   * Get the policy configuration at the API Operation level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperationPolicy_Get")
  get is ArmResourceRead<
    PolicyContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PolicyContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiOperationPolicy_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PolicyContract,
      BaseParameters<PolicyContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates or updates policy configuration for the API Operation level.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperationPolicy_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PolicyContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PolicyContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiOperationPolicy_Delete")
  delete is ArmResourceDeleteSync<
    PolicyContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<PolicyContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiOperationPolicy_ListByOperation")
  listByOperation is ArmResourceListByParent<PolicyContract>;
}

@@encodedName(PolicyContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(PolicyContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PolicyContracts.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
