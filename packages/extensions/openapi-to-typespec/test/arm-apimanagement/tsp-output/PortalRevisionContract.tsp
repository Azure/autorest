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
 * Portal Revision's contract details.
 */
@parentResource(ApiManagementServiceResource)
model PortalRevisionContract
  is Azure.ResourceManager.ProxyResource<PortalRevisionContractProperties> {
  ...ResourceNameParameter<
    Resource = PortalRevisionContract,
    KeyName = "portalRevisionId",
    SegmentName = "portalRevisions",
    NamePattern = ""
  >;
}

@armResourceOperations
interface PortalRevisionContracts {
  /**
   * Gets the developer portal's revision specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PortalRevision_Get")
  get is ArmResourceRead<PortalRevisionContract>;

  /**
   * Gets the developer portal revision specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @head
  @operationId("PortalRevision_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalRevisionContract,
      BaseParameters<PortalRevisionContract>
    >,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new developer portal's revision by running the portal's publishing. The `isCurrent` property indicates if the revision is publicly accessible.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PortalRevision_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<PortalRevisionContract>;

  /**
   * Updates the description of specified portal revision or makes it current.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("PortalRevision_Update")
  update is ArmCustomPatchAsync<
    PortalRevisionContract,
    PortalRevisionContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists developer portal's revisions.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("PortalRevision_ListByService")
  listByService is ArmResourceListByParent<
    PortalRevisionContract,
    Parameters = {
      /**
       * | Field       | Supported operators    | Supported functions               |
       * |-------------|------------------------|-----------------------------------|
       *
       * |name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
       * |description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
       * |isCurrent | eq, ne |    |
       *
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

@@maxLength(PortalRevisionContract.name, 256);
@@minLength(PortalRevisionContract.name, 1);
@@doc(PortalRevisionContract.name,
  "Portal revision identifier. Must be unique in the current API Management service instance."
);
@@doc(PortalRevisionContract.properties, "Properties of the portal revisions.");
@@doc(PortalRevisionContracts.createOrUpdate::parameters.resource, "");
@@doc(PortalRevisionContracts.update::parameters.properties, "");
