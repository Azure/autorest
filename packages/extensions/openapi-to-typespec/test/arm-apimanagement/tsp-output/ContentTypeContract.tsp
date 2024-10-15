import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Content type contract details.
 */
@parentResource(ApiManagementServiceResource)
model ContentTypeContract
  is Azure.ResourceManager.ProxyResource<ContentTypeContractProperties> {
  ...ResourceNameParameter<
    Resource = ContentTypeContract,
    KeyName = "contentTypeId",
    SegmentName = "contentTypes",
    NamePattern = ""
  >;
}

@armResourceOperations
interface ContentTypeContracts {
  /**
   * Gets the details of the developer portal's content type. Content types describe content items' properties, validation rules, and constraints.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentType_Get")
  get is ArmResourceRead<ContentTypeContract>;

  /**
   * Creates or updates the developer portal's content type. Content types describe content items' properties, validation rules, and constraints. Custom content types' identifiers need to start with the `c-` prefix. Built-in content types can't be modified.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentType_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    ContentTypeContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Removes the specified developer portal's content type. Content types describe content items' properties, validation rules, and constraints. Built-in content types (with identifiers starting with the `c-` prefix) can't be removed.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ContentType_Delete")
  delete is ArmResourceDeleteSync<
    ContentTypeContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists the developer portal's content types. Content types describe content items' properties, validation rules, and constraints.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ContentType_ListByService")
  listByService is ArmResourceListByParent<
    ContentTypeContract,
    Response = ContentTypeListResult
  >;
}

@@maxLength(ContentTypeContract.name, 80);
@@minLength(ContentTypeContract.name, 1);
@@doc(ContentTypeContract.name, "Content type identifier.");
@@doc(ContentTypeContract.properties, "Properties of the content type.");
