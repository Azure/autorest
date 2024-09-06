import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Create or update Restore Point collection parameters.
 */
model RestorePointCollection
  is Azure.ResourceManager.TrackedResource<RestorePointCollectionProperties> {
  ...ResourceNameParameter<
    Resource = RestorePointCollection,
    KeyName = "restorePointCollectionName",
    SegmentName = "restorePointCollections",
    NamePattern = ""
  >;
}

@armResourceOperations
interface RestorePointCollections {
  /**
   * The operation to get the restore point collection.
   */
  get is ArmResourceRead<
    RestorePointCollection,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<RestorePointCollection>;

      /**
       * The expand expression to apply on the operation. If expand=restorePoints, server will return all contained restore points in the restorePointCollection.
       */
      @query("$expand")
      $expand?: RestorePointCollectionExpandOptions;
    }
  >;

  /**
   * The operation to create or update the restore point collection. Please refer to https://aka.ms/RestorePoints for more details. When updating a restore point collection, only tags may be modified.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<RestorePointCollection>;

  /**
   * The operation to update the restore point collection.
   */
  @parameterVisibility
  update is ArmCustomPatchSync<
    RestorePointCollection,
    RestorePointCollectionUpdate
  >;

  /**
   * The operation to delete the restore point collection. This operation will also delete all the contained restore points.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<RestorePointCollection>;

  /**
   * Gets the list of restore point collections in a resource group.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RestorePointCollections_List")
  list is ArmResourceListByParent<RestorePointCollection>;

  /**
   * Gets the list of restore point collections in the subscription. Use nextLink property in the response to get the next page of restore point collections. Do this till nextLink is not null to fetch all the restore point collections.
   */
  listAll is ArmListBySubscription<RestorePointCollection>;
}

@@doc(RestorePointCollection.name, "The name of the restore point collection.");
@@doc(RestorePointCollection.properties,
  "The restore point collection properties."
);
@@encodedName(RestorePointCollections.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(RestorePointCollections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RestorePointCollections.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create or Update restore point collection operation."
);
@@encodedName(RestorePointCollections.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(RestorePointCollections.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(RestorePointCollections.update::parameters.properties,
  "Parameters supplied to the Update restore point collection operation."
);
