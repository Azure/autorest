import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./Catalog.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Microsoft.AzureSphere;
@doc("An image resource belonging to a catalog resource.")
@parentResource(Catalog)
model Image is ProxyResource<ImageProperties> {
  @doc("Image name. Use .default for image creation.")
  @path
  @key("imageName")
  @segment("images")
  imageName: string;
}
