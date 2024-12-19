import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Issue Contract details.
 */
@parentResource(ApiContract)
model IssueContract
  is Azure.ResourceManager.ProxyResource<IssueContractProperties> {
  ...ResourceNameParameter<
    Resource = IssueContract,
    KeyName = "issueId",
    SegmentName = "issues",
    NamePattern = "^[^*#&+:<>?]+$"
  >;
}

@armResourceOperations
interface IssueContracts {
  /**
   * Gets the details of the Issue for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_Get")
  get is ArmResourceRead<
    IssueContract,
    Parameters = {
      /**
       * Expand the comment attachments.
       */
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;
    }
  >;

  /**
   * Gets the entity state (Etag) version of the Issue for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_GetEntityTag")
  getEntityTag is ArmResourceCheckExistence<IssueContract>;

  /**
   * Creates a new Issue for an API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueContract,
    Parameters = {
      /**
       * ETag of the Entity. Not required when creating an entity, but required when updating an entity.
       */
      @header
      `If-Match`?: string;
    }
  >;

  /**
   * Updates an existing issue for an API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("ApiIssue_Update")
  update is ArmCustomPatchSync<
    IssueContract,
    PatchModel = IssueUpdateContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Deletes the specified Issue from an API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_Delete")
  delete is ArmResourceDeleteSync<
    IssueContract,
    Parameters = {
      /**
       * ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.
       */
      @header
      `If-Match`: string;
    }
  >;

  /**
   * Lists all issues associated with the specified API.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("ApiIssue_ListByService")
  listByService is ArmResourceListByParent<
    IssueContract,
    Parameters = {
      /**
       * |     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>
       */
      @query("$filter")
      $filter?: string;

      /**
       * Expand the comment attachments.
       */
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;

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

@@maxLength(IssueContract.name, 256);
@@minLength(IssueContract.name, 1);
@@doc(IssueContract.name,
  "Issue identifier. Must be unique in the current API Management service instance."
);
@@doc(IssueContract.properties, "Properties of the Issue.");
@@doc(IssueContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@doc(IssueContracts.update::parameters.properties, "Update parameters.");
