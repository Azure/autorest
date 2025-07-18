import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Workspace.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Workspace)
model DatastoreResource
  is Azure.ResourceManager.ProxyResource<Datastore, false> {
  ...ResourceNameParameter<
    Resource = DatastoreResource,
    KeyName = "name",
    SegmentName = "datastores",
    NamePattern = ""
  >;
}

@armResourceOperations
interface DatastoreResources {
  /**
   * Get datastore.
   */
  get is ArmResourceRead<DatastoreResource>;

  /**
   * Create or update datastore.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DatastoreResource,
    Parameters = {
      /**
       * Flag to skip validation.
       */
      @query("skipValidation")
      skipValidation?: boolean;
    }
  >;

  /**
   * Delete datastore.
   */
  delete is ArmResourceDeleteSync<DatastoreResource>;

  /**
   * List datastores.
   */
  list is ArmResourceListByParent<
    DatastoreResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * Maximum number of results to return.
       */
      @query("count")
      count?: int32 = 30;

      /**
       * Filter down to the workspace default datastore.
       */
      @query("isDefault")
      isDefault?: boolean;

      /**
       * Names of datastores to return.
       */
      @query("names")
      names?: string[];

      /**
       * Text to search for in the datastore names.
       */
      @query("searchText")
      searchText?: string;

      /**
       * Order by property (createdtime | modifiedtime | name).
       */
      @query("orderBy")
      orderBy?: string;

      /**
       * Order by property in ascending order.
       */
      @query("orderByAsc")
      orderByAsc?: boolean;
    },
    Response = ArmResponse<DatastoreResourceArmPaginatedResult>
  >;

  /**
   * Get datastore secrets.
   */
  listSecrets is ArmResourceActionSync<
    DatastoreResource,
    void,
    ArmResponse<DatastoreSecrets>
  >;
}

@@doc(DatastoreResource.name, "Datastore name.");
@@doc(DatastoreResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(DatastoreResources.createOrUpdate::parameters.resource,
  "Datastore entity to create or update."
);
