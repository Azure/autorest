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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Workspace)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(Datastore)
model DatastoreResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DatastoreResource,
    KeyName = "name",
    SegmentName = "datastores",
    NamePattern = ""
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: Datastore;
}

@armResourceOperations
interface DatastoreResources {
  /**
   * Get datastore.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Datastores_Get")
  get is ArmResourceRead<DatastoreResource>;

  /**
   * Create or update datastore.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Datastores_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    DatastoreResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DatastoreResource>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Datastores_Delete")
  delete is ArmResourceDeleteSync<DatastoreResource>;

  /**
   * List datastores.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Datastores_List")
  list is ArmResourceListByParent<
    DatastoreResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DatastoreResource>;

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
      @query({
        name: "names",
        format: "csv",
      })
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
    }
  >;

  /**
   * Get datastore secrets.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Datastores_ListSecrets")
  listSecrets is ArmResourceActionSync<
    DatastoreResource,
    void,
    DatastoreSecrets
  >;
}

@@doc(DatastoreResource.name, "Datastore name.");
@@encodedName(DatastoreResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(DatastoreResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(DatastoreResources.createOrUpdate::parameters.resource,
  "Datastore entity to create or update."
);
