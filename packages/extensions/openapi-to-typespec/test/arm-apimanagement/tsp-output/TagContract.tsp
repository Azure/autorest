import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tag Contract details.")
@parentResource(OperationContract)
model TagContract is ProxyResource<TagContractProperties> {
  @doc("Tag identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @key("tagId")
  @segment("tags")
  name: string;
}

@armResourceOperations
interface Tag {
  @doc("Get tag associated with the Operation.")
  getByOperation is ArmResourceRead<TagContract>;
  @doc("Gets the entity state version of the tag specified by its identifier.")
  @head
  getEntityStateByOperation(
    ...ResourceInstanceParameters<TagContract, BaseParameters<TagContract>>,
  ): OkResponse | ErrorResponse;
  @doc("Assign tag to the Operation.")
  assignToOperation is ArmResourceCreateOrReplaceSync<TagContract>;
  @doc("Detach the tag from the Operation.")
  detachFromOperation is ArmResourceDeleteSync<TagContract>;
  @doc("Lists all Tags associated with the Operation.")
  listByOperation is ArmResourceListByParent<
    TagContract,
    {
      ...BaseParameters<TagContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Number of records to return.")
      @minValue(1)
      @query("$top")
      $top?: int32;

      @doc("Number of records to skip.")
      @query("$skip")
      $skip?: int32;
    }
  >;
}
