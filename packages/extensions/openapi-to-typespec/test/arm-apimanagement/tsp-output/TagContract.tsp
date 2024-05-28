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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(OperationContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(TagContractProperties)
model TagContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = TagContract,
    KeyName = "tagId",
    SegmentName = "tags",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Tag entity contract properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: TagContractProperties;
}

@armResourceOperations
interface TagContracts {
  /**
   * Get tag associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Tag_GetByOperation")
  getByOperation is ArmResourceRead<TagContract>;

  /**
   * Gets the entity state version of the tag specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("Tag_GetEntityStateByOperation")
  getEntityStateByOperation(
    ...ResourceInstanceParameters<TagContract, BaseParameters<TagContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Assign tag to the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Tag_AssignToOperation")
  assignToOperation is ArmResourceCreateOrReplaceSync<TagContract>;

  /**
   * Detach the tag from the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Tag_DetachFromOperation")
  detachFromOperation is ArmResourceDeleteSync<TagContract>;

  /**
   * Lists all Tags associated with the Operation.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Tag_ListByOperation")
  listByOperation is ArmResourceListByParent<
    TagContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<TagContract>;

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
