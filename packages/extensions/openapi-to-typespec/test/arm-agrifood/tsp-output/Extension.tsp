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
 * Extension resource.
 */
@parentResource(DataManagerForAgriculture)
model Extension is Azure.ResourceManager.ProxyResource<ExtensionProperties> {
  ...ResourceNameParameter<
    Resource = Extension,
    KeyName = "extensionId",
    SegmentName = "extensions",
    NamePattern = ""
  >;
  ...Azure.ResourceManager.EntityTagProperty;
}

@armResourceOperations
interface Extensions {
  /**
   * Get installed extension details by extension id.
   */
  get is ArmResourceRead<Extension>;

  /**
   * Install or Update extension. Additional Api Properties are merged patch and if the extension is updated to a new version then the obsolete entries will be auto deleted from Additional Api Properties.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<Extension>;

  /**
   * Uninstall extension.
   */
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteSync<Extension>;

  /**
   * Get installed extensions details.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Extensions_ListByDataManagerForAgriculture")
  listByDataManagerForAgriculture is ArmResourceListByParent<
    Extension,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Extension>;

      /**
       * Installed extension ids.
       */
      @query(#{ name: "extensionIds", explode: true })
      extensionIds?: string[];

      /**
       * Installed extension categories.
       */
      @query(#{ name: "extensionCategories", explode: true })
      extensionCategories?: string[];

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

@@doc(Extension.name, "Id of extension resource.");
@@doc(Extension.properties, "Extension resource properties.");
@@encodedName(Extensions.createOrUpdate::parameters.resource,
  "application/json",
  "requestBody"
);
@@extension(Extensions.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "requestBody"
);
@@doc(Extensions.createOrUpdate::parameters.resource,
  "Extension resource request body."
);
