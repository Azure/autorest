import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./OperationContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Tag Contract details.
 */
@parentResource(OperationContract)
model TagContract
  is Azure.ResourceManager.ProxyResource<TagContractProperties> {
  ...ResourceNameParameter<
    Resource = TagContract,
    KeyName = "tagId",
    SegmentName = "tags",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface TagContracts {
  /**
   * Get tag associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetByOperation")
  getByOperation is ArmResourceRead<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_GetEntityStateByOperation")
  getEntityStateByOperation is ArmResourceCheckExistence<TagContract>;

  // FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.
  /**
   * Assign tag to the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_AssignToOperation")
  assignToOperation is ArmResourceCreateOrReplaceSync<TagContract>;

  /**
   * Detach the tag from the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_DetachFromOperation")
  detachFromOperation is ArmResourceDeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Tag_ListByOperation")
  listByOperation is ArmResourceListByParent<
    TagContract,
    Parameters = {
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

@@maxLength(TagContract.name, 80);
@@minLength(TagContract.name, 1);
@@doc(TagContract.name,
  "Tag identifier. Must be unique in the current API Management service instance."
);
@@doc(TagContract.properties, "Tag entity contract properties.");
