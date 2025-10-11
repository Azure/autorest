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

namespace Microsoft.AgFoodPlatform;
/** DataConnector Model. */
@parentResource(DataManagerForAgriculture)
model DataConnector
  is Azure.ResourceManager.ProxyResource<DataConnectorProperties, false> {
  ...ResourceNameParameter<
    Resource = DataConnector,
    KeyName = "dataConnectorName",
    SegmentName = "dataConnectors",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.EntityTagProperty;
}

@armResourceOperations
interface DataConnectors {
  /** Get specific Data Connector resource by DataConnectorName. */
  get is ArmResourceRead<DataConnector>;

  /** Create or update Data Connector For MADMA resource. */
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataConnector>;

  /** Delete a Data Connectors with given dataConnector name. */
  delete is ArmResourceDeleteSync<DataConnector>;

  /** Lists the Data Connector Credentials for MADMA instance. */
  list is ArmResourceListByParent<
    DataConnector,
    Parameters = {
      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      /** Continuation token for getting next set of results. */
      @query("$skipToken")
      $skipToken?: string;
    },
    Response = ArmResponse<DataConnectorListResponse>
  >;
}

@@maxLength(DataConnector.name, 63);
@@minLength(DataConnector.name, 1);
@@doc(DataConnector.name, "Connector name.");
@@doc(DataConnector.properties, "DataConnector Properties.");
@@doc(DataConnectors.createOrUpdate::parameters.resource,
  "Body must be valid DataConnector request."
);
