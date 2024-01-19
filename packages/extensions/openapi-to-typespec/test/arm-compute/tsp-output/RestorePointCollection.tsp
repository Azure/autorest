import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Create or update Restore Point collection parameters.
 */
model RestorePointCollection
  is TrackedResource<RestorePointCollectionProperties> {
  /**
   * The name of the restore point collection.
   */
  @path
  @key("restorePointCollectionName")
  @segment("restorePointCollections")
  name: string;
}

@armResourceOperations
interface RestorePointCollections {
  /**
   * The operation to get the restore point collection.
   */
  get is ArmResourceRead<
    RestorePointCollection,
    {
      ...BaseParameters<RestorePointCollection>;

      /**
       * The name of the restore point collection.
       */
      @path
      restorePointCollectionName: string;

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
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    RestorePointCollection,
    {
      ...BaseParameters<RestorePointCollection>;

      /**
       * The name of the restore point collection.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

  /**
   * The operation to update the restore point collection.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    RestorePointCollection,
    RestorePointCollectionUpdate,
    {
      ...BaseParameters<RestorePointCollection>;

      /**
       * The name of the restore point collection.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

  /**
   * The operation to delete the restore point collection. This operation will also delete all the contained restore points.
   */
  delete is ArmResourceDeleteAsync<
    RestorePointCollection,
    {
      ...BaseParameters<RestorePointCollection>;

      /**
       * The name of the Restore Point Collection.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

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

@@projectedName(RestorePointCollections.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(RestorePointCollections.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RestorePointCollections.createOrUpdate::parameters.resource,
  "Parameters supplied to the Create or Update restore point collection operation."
);
@@projectedName(RestorePointCollections.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(RestorePointCollections.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(RestorePointCollections.update::parameters.properties,
  "Parameters supplied to the Update restore point collection operation."
);
