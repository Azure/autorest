import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./RestorePointCollection.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Restore Point details.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(RestorePointCollection)
@includeInapplicableMetadataInPayload(false)
model RestorePoint extends ProxyResource {
  ...ResourceNameParameter<
    Resource = RestorePoint,
    KeyName = "restorePointName",
    SegmentName = "restorePoints",
    NamePattern = ""
  >;

  /**
   * The restore point properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: RestorePointProperties;
}

@armResourceOperations
interface RestorePoints {
  /**
   * The operation to get the restore point.
   */
  get is ArmResourceRead<
    RestorePoint,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<RestorePoint>;

      /**
       * The name of the restore point collection.
       */
      @path
      restorePointCollectionName: string;

      /**
       * The expand expression to apply on the operation. 'InstanceView' retrieves information about the run-time state of a restore point.
       */
      @query("$expand")
      $expand?: RestorePointExpandOptions;
    }
  >;

  /**
   * The operation to create the restore point. Updating properties of an existing restore point is not allowed
   */
  create is ArmResourceCreateOrReplaceAsync<
    RestorePoint,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<RestorePoint>;

      /**
       * The name of the restore point collection.
       */
      @path
      restorePointCollectionName: string;
    }
  >;

  /**
   * The operation to delete the restore point.
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<
    RestorePoint,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<RestorePoint>;

      /**
       * The name of the Restore Point Collection.
       */
      @path
      restorePointCollectionName: string;
    }
  >;
}

@@doc(RestorePoint.name, "The name of the restore point.");
@@encodedName(RestorePoints.create::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(RestorePoints.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(RestorePoints.create::parameters.resource,
  "Parameters supplied to the Create restore point operation."
);
