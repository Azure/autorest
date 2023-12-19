import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Gateway details.")
@parentResource(ApiManagementService)
model ApiManagementGateway is ProxyResource<GatewayContractProperties> {
  @doc("Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'")
  @maxLength(80)
  @minLength(1)
  @path
  @key("gatewayId")
  @segment("gateways")
  name: string;
}

@armResourceOperations
interface ApiManagementGateways {
  @doc("Gets the details of the Gateway specified by its identifier.")
  get is ArmResourceRead<ApiManagementGateway>;
  @doc("Gets the entity state (Etag) version of the Gateway specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementGateway,
      BaseParameters<ApiManagementGateway>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates or updates a Gateway to be used in Api Management instance.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ApiManagementGateway,
    {
      ...BaseParameters<ApiManagementGateway>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;
  @doc("Updates the details of the gateway specified by its identifier.")
  update is ArmResourcePatchSync<
    ApiManagementGateway,
    GatewayContractProperties,
    {
      ...BaseParameters<ApiManagementGateway>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Deletes specific Gateway.")
  delete is ArmResourceDeleteSync<
    ApiManagementGateway,
    {
      ...BaseParameters<ApiManagementGateway>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists a collection of gateways registered with service instance.")
  listByService is ArmResourceListByParent<
    ApiManagementGateway,
    {
      ...BaseParameters<ApiManagementGateway>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| region | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| description | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
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
  @doc("Retrieves gateway keys.")
  listKeys is ArmResourceActionSync<
    ApiManagementGateway,
    void,
    GatewayKeysContract
  >;
  @doc("Regenerates specified gateway key invalidating any tokens created with it.")
  regenerateKey is ArmResourceActionNoContentSync<
    ApiManagementGateway,
    GatewayKeyRegenerationRequestContract
  >;
  @doc("Gets the Shared Access Authorization Token for the gateway.")
  generateToken is ArmResourceActionSync<
    ApiManagementGateway,
    GatewayTokenRequestContract,
    GatewayTokenContract
  >;
  @doc("Lists a collection of the APIs associated with a gateway.")
  @route("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ApiManagement/service/{serviceName}/gateways/{gatewayId}/apis")
  @get
  ListByService is Azure.Core.Foundations.Operation<
    {
      @doc("The name of the resource group.")
      @path
      resourceGroupName: string;

      @doc("The name of the API Management service.")
      @maxLength(50)
      @minLength(1)
      @pattern("^[a-zA-Z](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?$")
      @path
      serviceName: string;

      @doc("Gateway entity identifier. Must be unique in the current API Management service instance. Must not have value 'managed'")
      @maxLength(80)
      @minLength(1)
      @path
      gatewayId: string;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;

      @doc("Subscription credentials which uniquely identify Microsoft Azure subscription. The subscription ID forms part of the URI for every service call.")
      @path
      subscriptionId: string;
    },
    ApiManagementGatewayApiListResult
  >;
}
