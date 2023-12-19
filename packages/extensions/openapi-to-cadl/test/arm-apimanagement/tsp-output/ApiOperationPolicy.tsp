import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiOperation.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Policy Contract details.")
@parentResource(ApiOperation)
model ApiOperationPolicy is ProxyResource<PolicyContractProperties> {
  @doc("The identifier of the Policy.")
  @path
  @key("policyId")
  @segment("policies")
  name: PolicyIdName;
}

@armResourceOperations
interface ApiOperationPolicies {
  @doc("Get the policy configuration at the API Operation level.")
  get is ArmResourceRead<
    ApiOperationPolicy,
    {
      ...BaseParameters<ApiOperationPolicy>;

      @doc("Policy Export Format.")
      @query("format")
      format?: PolicyExportFormat = "xml";
    }
  >;
  @doc("Gets the entity state (Etag) version of the API operation policy specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiOperationPolicy,
      BaseParameters<ApiOperationPolicy>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or updates policy configuration for the API Operation level.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiOperationPolicy,
    {
      ...BaseParameters<ApiOperationPolicy>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Deletes the policy configuration at the Api Operation.")
  delete is ArmResourceDeleteSync<
    ApiOperationPolicy,
    {
      ...BaseParameters<ApiOperationPolicy>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Get the list of policy configuration at the API Operation level.")
  listByOperation is ArmResourceListByParent<ApiOperationPolicy>;
}
