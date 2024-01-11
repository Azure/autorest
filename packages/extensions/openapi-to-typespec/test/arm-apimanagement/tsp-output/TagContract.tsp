import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
@doc("Tag Contract details.")
@parentResource(OperationContract)
model TagContract is ProxyResource<TagContractProperties> {
  @doc("Tag identifier. Must be unique in the current API Management service instance.")
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("tagId")
  @segment("tags")
  name: string;
}

@armResourceOperations
interface TagContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get tag associated with the Operation.")
  @operationId("Tag_GetByOperation")
  getByOperation is ArmResourceRead<TagContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state version of the tag specified by its identifier.")
  @head
  @operationId("Tag_GetEntityStateByOperation")
  getEntityStateByOperation(
    ...ResourceInstanceParameters<TagContract, BaseParameters<TagContract>>,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Assign tag to the Operation.")
  @operationId("Tag_AssignToOperation")
  assignToOperation is ArmResourceCreateOrReplaceSync<TagContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Detach the tag from the Operation.")
  @operationId("Tag_DetachFromOperation")
  detachFromOperation is ArmResourceDeleteSync<TagContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all Tags associated with the Operation.")
  @operationId("Tag_ListByOperation")
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
