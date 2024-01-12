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
@doc("Policy Contract details.")
@parentResource(OperationContract)
model PolicyContract is ProxyResource<PolicyContractProperties> {
  @doc("The identifier of the Policy.")
  @path
  @key("policyId")
  @segment("policies")
  name: PolicyIdName;
}

@armResourceOperations
interface PolicyContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get the policy configuration at the API Operation level.")
  @operationId("ApiOperationPolicy_Get")
  get is ArmResourceRead<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the API operation policy specified by its identifier.")
  @head
  @operationId("ApiOperationPolicy_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PolicyContract,
      BaseParameters<PolicyContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates or updates policy configuration for the API Operation level.")
  @operationId("ApiOperationPolicy_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the policy configuration at the Api Operation.")
  @operationId("ApiOperationPolicy_Delete")
  delete is ArmResourceDeleteSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get the list of policy configuration at the API Operation level.")
  @operationId("ApiOperationPolicy_ListByOperation")
  listByOperation is ArmResourceListByParent<PolicyContract>;
}

@@projectedName(PolicyContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(PolicyContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PolicyContracts.createOrUpdate::parameters.resource,
  "The policy contents to apply."
);
