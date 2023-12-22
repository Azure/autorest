import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./GatewayContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Gateway hostname configuration details.")
@parentResource(GatewayContract)
model GatewayHostnameConfigurationContract
  is ProxyResource<GatewayHostnameConfigurationContractProperties> {
  @doc("Gateway hostname configuration identifier. Must be unique in the scope of parent Gateway entity.")
  @maxLength(80)
  @minLength(1)
  @path
  @key("hcId")
  @segment("hostnameConfigurations")
  name: string;
}

@armResourceOperations
interface GatewayHostnameConfiguration {
  @doc("Get details of a hostname configuration")
  get is ArmResourceRead<GatewayHostnameConfigurationContract>;
  @doc("Checks that hostname configuration entity specified by identifier exists for specified Gateway entity.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      GatewayHostnameConfigurationContract,
      BaseParameters<GatewayHostnameConfigurationContract>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates of updates hostname configuration for a Gateway.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Deletes the specified hostname configuration from the specified Gateway.")
  delete is ArmResourceDeleteSync<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists the collection of hostname configurations for the specified gateway.")
  listByService is ArmResourceListByParent<
    GatewayHostnameConfigurationContract,
    {
      ...BaseParameters<GatewayHostnameConfigurationContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| hostname | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
