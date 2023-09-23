import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

@parentResource("Catalog")
model Image is ProxyResource<ImageProperties> {
  @doc("Image name. Use .default for image creation.")
  @key("imageName")
  @path
  name: string;
}
