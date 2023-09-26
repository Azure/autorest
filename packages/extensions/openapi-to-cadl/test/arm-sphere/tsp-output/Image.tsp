import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@doc("An image resource belonging to a catalog resource.")
@parentResource("Catalog")
model Image is ProxyResource<ImageProperties> {
  @doc("Image name. Use .default for image creation.")
  @key("imageName")
  @path
  @segment("images")
  name: string;
}

@armResourceOperations
interface Images
  extends Azure.ResourceManager.ProxyResourceOperations<
      Image,
      ImageProperties
    > {}
