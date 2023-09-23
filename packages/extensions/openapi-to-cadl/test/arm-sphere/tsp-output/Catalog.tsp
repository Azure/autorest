import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

model Catalog is TrackedResource<CatalogProperties> {
  @doc("Name of catalog")
  @key("catalogName")
  @pattern("^[A-Za-z0-9_-]{1,50}$")
  @path
  name: string;
}
