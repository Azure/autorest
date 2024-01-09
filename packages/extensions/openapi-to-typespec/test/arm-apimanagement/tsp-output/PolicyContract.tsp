import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Policy Contract details.")
@parentResource(OperationContract)
model PolicyContract is ProxyResource<PolicyContractProperties> {
  @doc("The identifier of the Policy.")
  @key("policyId")
  @segment("policies")
  name: PolicyIdName;
}

@armResourceOperations
@projectedName("client", "ApiOperationPolicy")
interface PolicyContracts_ApiOperationPolicy {
  @doc("Get the policy configuration at the API Operation level.")
  get is ArmResourceRead<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = PolicyExportFormat.xml;
    }
  >;

  @doc("Gets the entity state (Etag) version of the API operation policy specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      PolicyContract,
      BaseParameters<PolicyContract>
    >,
  ): OkResponse | ErrorResponse;

  @doc("Creates or updates policy configuration for the API Operation level.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  @doc("Deletes the policy configuration at the Api Operation.")
  delete is ArmResourceDeleteSync<
    PolicyContract,
    {
      ...BaseParameters<PolicyContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  @doc("Get the list of policy configuration at the API Operation level.")
  listByOperation is ArmResourceListByParent<PolicyContract>;
}
