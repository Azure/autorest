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
 * Solution resource.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(DataManagerForAgriculture)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(SolutionProperties)
model Solution extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = Solution,
    KeyName = "solutionId",
    SegmentName = "solutions",
    NamePattern = "^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$"
  >;

  /**
   * Solution resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: SolutionProperties;

  ...Azure.ResourceManager.EntityTagProperty;
}

@armResourceOperations
interface Solutions {
  /**
   * Get installed Solution details by Solution id.
   */
  get is ArmResourceRead<Solution>;

  /**
   * Install Or Update Solution.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Solution>;

  /**
   * Uninstall Solution.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<Solution>;

  /**
   * Get installed Solutions details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Solutions_List")
  list is ArmResourceListByParent<
    Solution,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Solution>;

      /**
       * Installed Solution ids.
       */
      @query({
        name: "solutionIds",
        format: "multi",
      })
      solutionIds?: string[];

      /**
       * Ids of the resource.
       */
      @query({
        name: "ids",
        format: "multi",
      })
      ids?: string[];

      /**
       * Names of the resource.
       */
      @query({
        name: "names",
        format: "multi",
      })
      names?: string[];

      /**
       * Filters on key-value pairs within the Properties object.
       * eg. "{testKey} eq {testValue}".
       */
      @query({
        name: "propertyFilters",
        format: "multi",
      })
      propertyFilters?: string[];

      /**
       * Statuses of the resource.
       */
      @query({
        name: "statuses",
        format: "multi",
      })
      statuses?: string[];

      /**
       * Minimum creation date of resource (inclusive).
       */
      @query("minCreatedDateTime")
      minCreatedDateTime?: utcDateTime;

      /**
       * Maximum creation date of resource (inclusive).
       */
      @query("maxCreatedDateTime")
      maxCreatedDateTime?: utcDateTime;

      /**
       * Minimum last modified date of resource (inclusive).
       */
      @query("minLastModifiedDateTime")
      minLastModifiedDateTime?: utcDateTime;

      /**
       * Maximum last modified date of resource (inclusive).
       */
      @query("maxLastModifiedDateTime")
      maxLastModifiedDateTime?: utcDateTime;

      /**
       * Maximum number of items needed (inclusive).
       * Minimum = 10, Maximum = 1000, Default value = 50.
       */
      @maxValue(1000)
      @minValue(10)
      @query("$maxPageSize")
      $maxPageSize?: int32 = 50;

      /**
       * Skip token for getting next set of results.
       */
      @query("$skipToken")
      $skipToken?: string;
    }
  >;
}

@@doc(Solution.name, "SolutionId for Data Manager For Agriculture Resource.");
@@encodedName(Solutions.createOrUpdate::parameters.resource,
  "application/json",
  "requestBody"
);
@@extension(Solutions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "requestBody"
);
@@doc(Solutions.createOrUpdate::parameters.resource,
  "Solution resource request body."
);
