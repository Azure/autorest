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
@doc("Azure Resource Manager resource envelope.")
@parentResource(Workspace)
model DatastoreResource is ProxyResource<Datastore> {
  @doc("Datastore name.")
  @key("name")
  @segment("datastores")
  name: string;
}

@armResourceOperations
interface Datastores {
  @doc("Get datastore.")
  get is ArmResourceRead<DatastoreResource>;
  @doc("Create or update datastore.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DatastoreResource,
    {
      ...BaseParameters<DatastoreResource>;

      @doc("Flag to skip validation.")
      @query("skipValidation")
      skipValidation?: boolean;
    }
  >;
  @doc("Delete datastore.")
  delete is ArmResourceDeleteSync<DatastoreResource>;
  @doc("List datastores.")
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
  @doc("Get datastore secrets.")
  listSecrets is ArmResourceActionSync<
    DatastoreResource,
    void,
    DatastoreSecrets
  >;
}
