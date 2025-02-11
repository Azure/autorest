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
/**
 * Solution resource.
 */
@parentResource(DataManagerForAgriculture)
model Solution is Azure.ResourceManager.ProxyResource<SolutionProperties> {
  ...ResourceNameParameter<
    Resource = Solution,
    KeyName = "solutionId",
    SegmentName = "solutions",
    NamePattern = "^[a-zA-Z]{3,50}[.][a-zA-Z]{3,100}$"
  >;
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
  delete is ArmResourceDeleteSync<Solution>;

  /**
   * Get installed Solutions details.
   */
  list is ArmResourceListByParent<
    Solution,
    Parameters = {
      /**
       * Installed Solution ids.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "solutionIds", explode: true })
      solutionIds?: string[];

      /**
       * Ids of the resource.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "ids", explode: true })
      ids?: string[];

      /**
       * Names of the resource.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "names", explode: true })
      names?: string[];

      /**
       * Filters on key-value pairs within the Properties object.
       * eg. "{testKey} eq {testValue}".
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "propertyFilters", explode: true })
      propertyFilters?: string[];

      /**
       * Statuses of the resource.
       */
      #suppress "@azure-tools/typespec-azure-core/no-query-explode" "For backward compatibility"
      @query(#{ name: "statuses", explode: true })
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
    },
    Response = ArmResponse<SolutionListResponse>
  >;
}

@@doc(Solution.name, "SolutionId for Data Manager For Agriculture Resource.");
@@doc(Solution.properties, "Solution resource properties.");
@@doc(Solutions.createOrUpdate::parameters.resource,
  "Solution resource request body."
);
