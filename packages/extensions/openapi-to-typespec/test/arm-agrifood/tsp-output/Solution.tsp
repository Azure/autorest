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
@doc("Solution resource.")
@parentResource(DataManagerForAgriculture)
model Solution is ProxyResource<SolutionProperties> {
  @doc("SolutionId for Data Manager For Agriculture Resource.")
  @pattern("^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$")
  @path
  @key("solutionId")
  @segment("solutions")
  name: string;

  ...Azure.ResourceManager.EntityTag;
}

@armResourceOperations
interface Solutions {
  @doc("Get installed Solution details by Solution id.")
  get is ArmResourceRead<Solution>;

  @doc("Install Or Update Solution.")
  createOrUpdate is ArmResourceCreateOrReplaceSync<Solution>;

  @doc("Uninstall Solution.")
  delete is ArmResourceDeleteSync<Solution>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get installed Solutions details.")
  @operationId("Solutions_List")
  list is ArmResourceListByParent<
    Solution,
    {
      ...BaseParameters<Solution>;

      @doc("Installed Solution ids.")
      @query({
        name: "solutionIds",
        format: "multi",
      })
      solutionIds?: string[];

      @doc("Ids of the resource.")
      @query({
        name: "ids",
        format: "multi",
      })
      ids?: string[];

      @doc("Names of the resource.")
      @query({
        name: "names",
        format: "multi",
      })
      names?: string[];

      @doc("""
Filters on key-value pairs within the Properties object.
eg. \"{testKey} eq {testValue}\".
""")
      @query({
        name: "propertyFilters",
        format: "multi",
      })
      propertyFilters?: string[];

      @doc("Statuses of the resource.")
      @query({
        name: "statuses",
        format: "multi",
      })
      statuses?: string[];

      @doc("Minimum creation date of resource (inclusive).")
      @query("minCreatedDateTime")
      minCreatedDateTime?: utcDateTime;

      @doc("Maximum creation date of resource (inclusive).")
      @query("maxCreatedDateTime")
      maxCreatedDateTime?: utcDateTime;

      @doc("Minimum last modified date of resource (inclusive).")
      @query("minLastModifiedDateTime")
      minLastModifiedDateTime?: utcDateTime;

      @doc("Maximum last modified date of resource (inclusive).")
      @query("maxLastModifiedDateTime")
      maxLastModifiedDateTime?: utcDateTime;

      @doc("""
Maximum number of items needed (inclusive).
Minimum = 10, Maximum = 1000, Default value = 50.
""")
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      @doc("Skip token for getting next set of results.")
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@projectedName(Solutions.createOrUpdate::parameters.resource,
  "json",
  "requestBody"
);
@@extension(Solutions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "requestBody"
);
@@doc(Solutions.createOrUpdate::parameters.resource,
  "Solution resource request body."
);
