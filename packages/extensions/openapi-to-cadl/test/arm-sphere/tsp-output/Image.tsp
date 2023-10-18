import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Sphere;
@doc("An image resource belonging to a catalog resource.")
@parentResource(Catalog)
model Image is ProxyResource<ImageProperties> {
  @doc("Image name. Use .default for image creation.")
  @path
  @key("imageName")
  @segment("images")
  name: string;
}

@armResourceOperations
interface Images {
  @doc("Get a Image")
  get is ArmResourceRead<Image>;
  @doc("Create a Image")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<Image>;
  @doc("Delete a Image")
  delete is ArmResourceDeleteAsync<Image>;
  @doc("List Image resources by Catalog")
  listByCatalog is ArmResourceListByParent<
    Image,
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
    }
  >;
}
