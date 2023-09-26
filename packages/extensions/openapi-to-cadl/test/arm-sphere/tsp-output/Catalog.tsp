import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

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
  @autoroute
  @doc("Counts devices in catalog.")
  @armResourceLocation(Catalog)
  @post
  countDevices(
    ...ResourceInstanceParameters<Catalog>
  ): ArmResponse<CountDeviceResponse> | ErrorResponse;
  @autoroute
  @doc("Lists deployments for catalog.")
  @armResourceLocation(Catalog)
  @post
  listDeployments(
    ...ResourceInstanceParameters<Catalog>,
    ...ListQueryParameters
  ): ArmResponse<ResourceListResult<DeploymentListResult>> | ErrorResponse;
  @autoroute
  @doc("List the device groups for the catalog.")
  @armResourceLocation(Catalog)
  @post
  listDeviceGroups(
    ...ResourceInstanceParameters<Catalog>,
    ...ListQueryParameters
  ): ArmResponse<ResourceListResult<DeviceGroupListResult>> | ErrorResponse;
  @autoroute
  @doc("Lists device insights for catalog.")
  @armResourceLocation(Catalog)
  @post
  listDeviceInsights(
    ...ResourceInstanceParameters<Catalog>,
    ...ListQueryParameters
  ): ArmResponse<Page<PagedDeviceInsight>> | ErrorResponse;
  @autoroute
  @doc("Lists devices for catalog.")
  @armResourceLocation(Catalog)
  @post
  listDevices(
    ...ResourceInstanceParameters<Catalog>,
    ...ListQueryParameters
  ): ArmResponse<ResourceListResult<DeviceListResult>> | ErrorResponse;
}
