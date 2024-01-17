import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

@parentResource(Workspace)
model OnlineEndpointTrackedResource is TrackedResource<OnlineEndpoint> {
  @doc("Online Endpoint name.")
  @path
  @key("endpointName")
  @segment("onlineEndpoints")
  name: string;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
  ...Azure.ResourceManager.ResourceKind;
}

@armResourceOperations
interface OnlineEndpointTrackedResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get Online Endpoint.")
  @operationId("OnlineEndpoints_Get")
  get is ArmResourceRead<OnlineEndpointTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update Online Endpoint (asynchronous).")
  @operationId("OnlineEndpoints_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<OnlineEndpointTrackedResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update Online Endpoint (asynchronous).")
  @parameterVisibility("read")
  @operationId("OnlineEndpoints_Update")
  update is ArmCustomPatchAsync<
    OnlineEndpointTrackedResource,
    PartialMinimalTrackedResourceWithIdentity
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete Online Endpoint (asynchronous).")
  @operationId("OnlineEndpoints_Delete")
  delete is ArmResourceDeleteAsync<
    OnlineEndpointTrackedResource,
    BaseParameters<OnlineEndpointTrackedResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List Online Endpoints.")
  @operationId("OnlineEndpoints_List")
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

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List EndpointAuthKeys for an Endpoint using Key-based authentication.")
  @operationId("OnlineEndpoints_ListKeys")
  listKeys is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    EndpointAuthKeys
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerate EndpointAuthKeys for an Endpoint using Key-based authentication (asynchronous).")
  @operationId("OnlineEndpoints_RegenerateKeys")
  regenerateKeys is ArmResourceActionAsync<
    OnlineEndpointTrackedResource,
    RegenerateEndpointKeysRequest,
    void,
    BaseParameters<OnlineEndpointTrackedResource>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Retrieve a valid AML token for an Endpoint using AMLToken-based authentication.")
  @operationId("OnlineEndpoints_GetToken")
  getToken is ArmResourceActionSync<
    OnlineEndpointTrackedResource,
    void,
    EndpointAuthToken
  >;
}

@@projectedName(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(OnlineEndpointTrackedResources.createOrUpdate::parameters.resource,
  "Online Endpoint entity to apply during operation."
);
@@projectedName(OnlineEndpointTrackedResources.update::parameters.properties,
  "json",
  "body"
);
@@extension(OnlineEndpointTrackedResources.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(OnlineEndpointTrackedResources.update::parameters.properties,
  "Online Endpoint entity to apply during operation."
);
@@doc(OnlineEndpointTrackedResources.regenerateKeys::parameters.body,
  "RegenerateKeys request ."
);
