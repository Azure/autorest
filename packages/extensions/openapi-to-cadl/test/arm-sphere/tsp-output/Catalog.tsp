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
  @key("catalogName")
  @path
  @segment("catalogs")
  name: string;
}

@armResourceOperations
interface Catalogs
  extends Azure.ResourceManager.TrackedResourceOperations<
      Catalog,
      CatalogProperties
    > {
  @autoRoute
  @doc("Counts devices in catalog.")
  @armResourceAction(Catalog)
  @post
  countDevices(
    ...ResourceInstanceParameters<Catalog>
  ): ArmResponse<CountDeviceResponse> | ErrorResponse;
  @autoRoute
  @doc("Lists deployments for catalog.")
  @armResourceAction(Catalog)
  @post
  listDeployments(
    ...ResourceInstanceParameters<Catalog>,

    @doc("Filter the result list using the given expression")
    @query
    $filter: string,

    @doc("The number of result items to return.")
    @query
    $top: int32,

    @doc("The number of result items to skip.")
    @query
    $skip: int32,

    @doc("The maximum number of result items per page.")
    @query
    $maxpagesize: int32
  ): ArmResponse<ResourceListResult<Deployment>> | ErrorResponse;
  @autoRoute
  @doc("List the device groups for the catalog.")
  @armResourceAction(Catalog)
  @post
  listDeviceGroups(
    ...ResourceInstanceParameters<Catalog>,

    @doc("Filter the result list using the given expression")
    @query
    $filter: string,

    @doc("The number of result items to return.")
    @query
    $top: int32,

    @doc("The number of result items to skip.")
    @query
    $skip: int32,

    @doc("The maximum number of result items per page.")
    @query
    $maxpagesize: int32,

    @doc("List device groups for catalog.")
    @body
    listDeviceGroupsRequest: ListDeviceGroupsRequest
  ): ArmResponse<ResourceListResult<DeviceGroup>> | ErrorResponse;
  @autoRoute
  @doc("Lists device insights for catalog.")
  @armResourceAction(Catalog)
  @post
  listDeviceInsights(
    ...ResourceInstanceParameters<Catalog>,

    @doc("Filter the result list using the given expression")
    @query
    $filter: string,

    @doc("The number of result items to return.")
    @query
    $top: int32,

    @doc("The number of result items to skip.")
    @query
    $skip: int32,

    @doc("The maximum number of result items per page.")
    @query
    $maxpagesize: int32
  ): ArmResponse<Page<PagedDeviceInsight>> | ErrorResponse;
  @autoRoute
  @doc("Lists devices for catalog.")
  @armResourceAction(Catalog)
  @post
  listDevices(
    ...ResourceInstanceParameters<Catalog>,

    @doc("Filter the result list using the given expression")
    @query
    $filter: string,

    @doc("The number of result items to return.")
    @query
    $top: int32,

    @doc("The number of result items to skip.")
    @query
    $skip: int32,

    @doc("The maximum number of result items per page.")
    @query
    $maxpagesize: int32
  ): ArmResponse<ResourceListResult<Device>> | ErrorResponse;
}
