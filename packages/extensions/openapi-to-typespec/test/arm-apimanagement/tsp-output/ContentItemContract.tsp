import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ContentTypeContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Content type contract details.
 */
@parentResource(ContentTypeContract)
model ContentItemContract
  is Azure.ResourceManager.ProxyResource<Record<unknown>> {
  ...ResourceNameParameter<
    Resource = ContentItemContract,
    KeyName = "contentItemId",
    SegmentName = "contentItems",
    NamePattern = ""
  >;
}

@armResourceOperations
interface ContentItemContracts {
  /**
   * Returns the developer portal's content item specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentItem_Get")
  get is ArmResourceRead<ContentItemContract>;

  /**
   * Returns the entity state (ETag) version of the developer portal's content item specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("ContentItem_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      ContentItemContract,
      BaseParameters<ContentItemContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new developer portal's content item specified by the provided content type.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentItem_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ContentItemContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Removes the specified developer portal's content item.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ContentItem_Delete")
  delete is ArmResourceDeleteSync<
    ContentItemContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists developer portal's content items specified by the provided content type.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentItem_ListByService")
  listByService is ArmResourceListByParent<
    ContentItemContract,
    Response = ContentItemListResult
  >;
}

@@maxLength(ContentItemContract.name, 80);
@@minLength(ContentItemContract.name, 1);
@@doc(ContentItemContract.name, "Content item identifier.");
@@doc(ContentItemContract.properties, "Properties of the content item.");
