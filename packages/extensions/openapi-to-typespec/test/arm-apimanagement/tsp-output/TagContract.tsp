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
/**
 * Tag Contract details.
 */
@parentResource(OperationContract)
model TagContract is ProxyResource<TagContractProperties> {
  /**
   * Tag identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(80)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("tagId")
  @segment("tags")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface TagContracts {
  /**
   * Get tag associated with the Operation.
   */
  getByOperation is ArmResourceRead<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  @head
  getEntityStateByOperation(
    ...ResourceInstanceParameters<TagContract, BaseParameters<TagContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Assign tag to the Operation.
   */
  assignToOperation is ArmResourceCreateOrReplaceSync<TagContract>;

  /**
   * Detach the tag from the Operation.
   */
  detachFromOperation is ArmResourceDeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the Operation.
   */
  listByOperation is ArmResourceListByParent<
    TagContract,
    {
      ...BaseParameters<TagContract>;

      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| displayName | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Number of records to return.
       */
      @minValue(1)
      @query("$top")
      $top?: int32;

      /**
       * Number of records to skip.
       */
      @query("$skip")
      $skip?: int32;
    }
  >;
}
