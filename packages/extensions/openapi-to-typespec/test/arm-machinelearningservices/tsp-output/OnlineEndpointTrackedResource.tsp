import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(Workspace)
model OnlineEndpointTrackedResource is TrackedResource<OnlineEndpoint> {
  @doc("Online Endpoint name.")
  @key("endpointName")
  @segment("onlineEndpoints")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
@projectedName("client", "OnlineEndpoints")
interface OnlineEndpointTrackedResources_OnlineEndpoints {
  @doc("Get Online Endpoint.")
  get is ArmResourceRead<OnlineEndpointTrackedResource>;
  @doc("Create or update Online Endpoint (asynchronous).")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<OnlineEndpointTrackedResource>;
  @doc("Update Online Endpoint (asynchronous).")
  update is ArmCustomPatchAsync<
    OnlineEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;
  @doc("Delete Online Endpoint (asynchronous).")
  delete is ArmResourceDeleteAsync<OnlineEndpointTrackedResource>;
  @doc("List Online Endpoints.")
  list is ArmResourceListByParent<
    OnlineEndpointTrackedResource,
    {
      ...BaseParameters<OnlineEndpointTrackedResource>;

      @doc("Name of the endpoint.")
      @query("name")
      name?: string;

      @doc("Number of endpoints to be retrieved in a page of results.")
      @query("count")
      count?: int32;

      @doc("EndpointComputeType to be filtered by.")
      @query("computeType")
      computeType?: EndpointComputeType;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("A set of tags with which to filter the returned models. It is a comma separated string of tags key or tags key=value. Example: tagKey1,tagKey2,tagKey3=value3 .")
      @query("tags")
      tags?: string;

      @doc("A set of properties with which to filter the returned models. It is a comma separated string of properties key and/or properties key=value Example: propKey1,propKey2,propKey3=value3 .")
      @query("properties")
      properties?: string;

      @doc("The option to order the response.")
      @query("orderBy")
      orderBy?: OrderString;
    }
  >;
  @doc("List EndpointAuthKeys for an Endpoint using Key-based authentication.")
  listKeys is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    EndpointAuthKeys
  >;
  @doc("Regenerate EndpointAuthKeys for an Endpoint using Key-based authentication (asynchronous).")
  regenerateKeys is ArmResourceActionAsync<
    OnlineEndpointTrackedResource,
    RegenerateEndpointKeysRequest,
    void
  >;
  @doc("Retrieve a valid AML token for an Endpoint using AMLToken-based authentication.")
  getToken is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    EndpointAuthToken
  >;
}
