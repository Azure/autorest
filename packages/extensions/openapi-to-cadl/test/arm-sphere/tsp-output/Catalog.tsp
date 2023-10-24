import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Sphere;
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
  // FIXME: (ArmResourceAction): ArmResourceActionSync/ArmResourceActionAsync should have a body parameter
  @doc("Counts devices in catalog.")
  countDevices is ArmResourceActionSync<Catalog, {}, CountDeviceResponse>;
  @doc("Lists deployments for catalog.")
  listDeployments is ArmResourceActionSync<
    Catalog,
    {
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
    },
    ResourceListResult<Deployment>
  >;
  @doc("List the device groups for the catalog.")
  listDeviceGroups is ArmResourceActionSync<
    Catalog,
    {
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

      ...ListDeviceGroupsRequest;
    },
    ResourceListResult<DeviceGroup>
  >;
  @doc("Lists device insights for catalog.")
  listDeviceInsights is ArmResourceActionSync<
    Catalog,
    {
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
    },
    PagedDeviceInsight
  >;
  @doc("Lists devices for catalog.")
  listDevices is ArmResourceActionSync<
    Catalog,
    {
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
    },
    ResourceListResult<Device>
  >;
}
