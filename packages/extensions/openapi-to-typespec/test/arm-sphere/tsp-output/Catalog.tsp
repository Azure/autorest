import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.AzureSphere;
/**
 * An Azure Sphere catalog
 */
model Catalog is Azure.ResourceManager.TrackedResource<CatalogProperties> {
  ...ResourceNameParameter<
    Resource = Catalog,
    KeyName = "catalogName",
    SegmentName = "catalogs",
    NamePattern = "^[A-Za-z0-9_-]{1,50}$"
  >;
}

@armResourceOperations
interface Catalogs {
  /**
   * Get a Catalog
   */
  get is ArmResourceRead<Catalog>;

  /**
   * Create a Catalog
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Catalog>;

  /**
   * Update a Catalog
   */
  @parameterVisibility
  update is ArmCustomPatchSync<Catalog, CatalogUpdate>;

  /**
   * Delete a Catalog
   */
  delete is ArmResourceDeleteAsync<Catalog>;

  /**
   * List Catalog resources by resource group
   */
  listByResourceGroup is ArmResourceListByParent<Catalog>;

  /**
   * List Catalog resources by subscription ID
   */
  listBySubscription is ArmListBySubscription<Catalog>;

  /**
   * Counts devices in catalog.
   */
  countDevices is ArmResourceActionSync<Catalog, void, CountDeviceResponse>;

  /**
   * Lists deployments for catalog.
   */
  listDeployments is ArmResourceActionSync<
    Catalog,
    void,
    ResourceListResult<Deployment>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Catalog>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;

  /**
   * List the device groups for the catalog.
   */
  listDeviceGroups is ArmResourceActionSync<
    Catalog,
    ListDeviceGroupsRequest,
    ResourceListResult<DeviceGroup>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Catalog>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;

  /**
   * Lists device insights for catalog.
   */
  listDeviceInsights is ArmResourceActionSync<
    Catalog,
    void,
    PagedDeviceInsight,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Catalog>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;

  /**
   * Lists devices for catalog.
   */
  listDevices is ArmResourceActionSync<
    Catalog,
    void,
    ResourceListResult<Device>,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<Catalog>;

      /**
       * Filter the result list using the given expression
       */
      @query("$filter")
      filter?: string;

      /**
       * The number of result items to return.
       */
      @query("$top")
      top?: int32;

      /**
       * The number of result items to skip.
       */
      @query("$skip")
      skip?: int32;

      /**
       * The maximum number of result items per page.
       */
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}

@@doc(Catalog.name, "Name of catalog");
@@doc(Catalogs.listDeviceGroups::parameters.body,
  "List device groups for catalog."
);
