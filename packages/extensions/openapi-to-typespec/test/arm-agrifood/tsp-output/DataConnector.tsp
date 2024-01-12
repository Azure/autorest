import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./DataManagerForAgriculture.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.AgFoodPlatform;
@doc("DataConnector Model.")
@parentResource(DataManagerForAgriculture)
model DataConnector is ProxyResource<DataConnectorProperties> {
  @doc("Connector name.")
  @maxLength(63)
  @minLength(1)
  @path
  @key("dataConnectorName")
  @segment("dataConnectors")
  name: string;

  ...Azure.ResourceManager.EntityTag;
}

@armResourceOperations
interface DataConnectors {
  @doc("Get specific Data Connector resource by DataConnectorName.")
  get is ArmResourceRead<DataConnector>;

  @doc("Create or update Data Connector For MADMA resource.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<DataConnector>;

  @doc("Delete a Data Connectors with given dataConnector name.")
  delete is ArmResourceDeleteSync<DataConnector>;

  @doc("Lists the Data Connector Credentials for MADMA instance.")
  list is ArmResourceListByParent<
    DataConnector,
    {
      ...BaseParameters<DataConnector>;

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      @doc("Continuation token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@projectedName(DataConnectors.createOrUpdate::parameters.resource,
  "json",
  "body"
);
@@extension(DataConnectors.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(DataConnectors.createOrUpdate::parameters.resource,
  "Body must be valid DataConnector request."
);
