import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
/**
 * DataConnector Model.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DataManagerForAgriculture)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(DataConnectorProperties)
model DataConnector extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = DataConnector,
    KeyName = "dataConnectorName",
    SegmentName = "dataConnectors",
    NamePattern = ""
  >;

  /**
   * DataConnector Properties.
   */
  @extension("x-ms-client-flatten", true)
  properties: DataConnectorProperties;

  ...Azure.ResourceManager.EntityTagProperty;
}

@armResourceOperations
interface DataConnectors {
  /**
   * Get specific Data Connector resource by DataConnectorName.
   */
  get is ArmResourceRead<DataConnector>;

  /**
   * Create or update Data Connector For MADMA resource.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataConnector>;

  /**
   * Delete a Data Connectors with given dataConnector name.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<DataConnector>;

  /**
   * Lists the Data Connector Credentials for MADMA instance.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("DataConnectors_List")
  list is ArmResourceListByParent<
    DataConnector,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<DataConnector>;

      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      /**
       * Continuation token for getting next set of results.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@maxLength(DataConnector.name, 63);
@@minLength(DataConnector.name, 1);
@@doc(DataConnector.name, "Connector name.");
@@encodedName(DataConnectors.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(DataConnectors.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(DataConnectors.createOrUpdate::parameters.resource,
  "Body must be valid DataConnector request."
);
