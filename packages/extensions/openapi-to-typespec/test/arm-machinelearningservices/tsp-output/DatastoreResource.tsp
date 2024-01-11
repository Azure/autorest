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
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model DatastoreResource is ProxyResource<Datastore> {
  @doc("Datastore name.")
  @path
  @key("name")
  @segment("datastores")
  name: string;
}

@armResourceOperations
interface DatastoreResources {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get datastore.")
  @operationId("Datastores_Get")
  get is ArmResourceRead<DatastoreResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Create or update datastore.")
  @operationId("Datastores_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DatastoreResource,
    {
      ...BaseParameters<DatastoreResource>;

      @doc("Flag to skip validation.")
      @query("skipValidation")
      skipValidation?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Delete datastore.")
  @operationId("Datastores_Delete")
  delete is ArmResourceDeleteSync<DatastoreResource>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("List datastores.")
  @operationId("Datastores_List")
  list is ArmResourceListByParent<
    DatastoreResource,
    {
      ...BaseParameters<DatastoreResource>;

      @doc("Continuation token for pagination.")
      @query("$skip")
      $skip?: string;

      @doc("Maximum number of results to return.")
      @query("count")
      count?: int32 = 30;

      @doc("Filter down to the workspace default datastore.")
      @query("isDefault")
      isDefault?: boolean;

      @doc("Names of datastores to return.")
      @query({
        name: "names",
        format: "csv",
      })
      names?: string[];

      @doc("Text to search for in the datastore names.")
      @query("searchText")
      searchText?: string;

      @doc("Order by property (createdtime | modifiedtime | name).")
      @query("orderBy")
      orderBy?: string;

      @doc("Order by property in ascending order.")
      @query("orderByAsc")
      orderByAsc?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get datastore secrets.")
  @operationId("Datastores_ListSecrets")
  listSecrets is ArmResourceActionSync<
    DatastoreResource,
    void,
    DatastoreSecrets
  >;
}
