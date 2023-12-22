import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An Azure Sphere catalog")
model Catalog is TrackedResource<CatalogProperties> {
  @doc("Name of catalog")
  @pattern("^[A-Za-z0-9_-]{1,50}$")
  @path
  @key("catalogName")
  @segment("catalogs")
  name: string;
}

@armResourceOperations
interface Catalogs {
  @doc("Get a Catalog")
  get is ArmResourceRead<Catalog>;
  @doc("Create a Catalog")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Catalog>;
  @doc("Update a Catalog")
  update is ArmTagsPatchSync<Catalog>;
  @doc("Delete a Catalog")
  delete is ArmResourceDeleteAsync<Catalog>;
  @doc("List Catalog resources by resource group")
  listByResourceGroup is ArmResourceListByParent<Catalog>;
  @doc("List Catalog resources by subscription ID")
  listBySubscription is ArmListBySubscription<Catalog>;
  @doc("Counts devices in catalog.")
  countDevices is ArmResourceActionSync<Catalog, void, CountDeviceResponse>;
  @doc("Lists deployments for catalog.")
  listDeployments is ArmResourceActionSync<
    Catalog,
    void,
    ResourceListResult<Deployment>,
    {
      ...BaseParameters<Catalog>;

      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
  @doc("List the device groups for the catalog.")
  listDeviceGroups is ArmResourceActionSync<
    Catalog,
    ListDeviceGroupsRequest,
    ResourceListResult<DeviceGroup>,
    {
      ...BaseParameters<Catalog>;

      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
  @doc("Lists device insights for catalog.")
  listDeviceInsights is ArmResourceActionSync<
    Catalog,
    void,
    PagedDeviceInsight,
    {
      ...BaseParameters<Catalog>;

      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
  @doc("Lists devices for catalog.")
  listDevices is ArmResourceActionSync<
    Catalog,
    void,
    ResourceListResult<Device>,
    {
      ...BaseParameters<Catalog>;

      @doc("Filter the result list using the given expression")
      @query("$filter")
      filter?: string;

      @doc("The number of result items to return.")
      @query("$top")
      top?: int32;

      @doc("The number of result items to skip.")
      @query("$skip")
      skip?: int32;

      @doc("The maximum number of result items per page.")
      @query("$maxpagesize")
      maxpagesize?: int32;
    }
  >;
}
