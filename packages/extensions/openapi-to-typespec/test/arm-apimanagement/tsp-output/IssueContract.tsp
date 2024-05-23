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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(ApiContract)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(IssueContractProperties)
model IssueContract extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = IssueContract,
    KeyName = "issueId",
    SegmentName = "issues",
    NamePattern = "^[^*#&+:<>?]+$"
  >;

  /**
   * Properties of the Issue.
   */
  @extension("x-ms-client-flatten", true)
  properties?: IssueContractProperties;
}

@armResourceOperations
interface IssueContracts {
  /**
   * Gets the details of the Issue for an API specified by its identifier.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssue_Get")
  get is ArmResourceRead<
    IssueContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @head
  @operationId("ApiIssue_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<IssueContract, BaseParameters<IssueContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Issue for an API or updates an existing one.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssue_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("ApiIssue_Update")
  update is ArmCustomPatchSync<
    IssueContract,
    IssueUpdateContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("ApiIssue_Delete")
  delete is ArmResourceDeleteSync<
    IssueContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueContract>;

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
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("ApiIssue_ListByService")
  listByService is ArmResourceListByParent<
    IssueContract,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<IssueContract>;

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
@@encodedName(IssueContracts.createOrUpdate::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(IssueContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@encodedName(IssueContracts.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(IssueContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueContracts.update::parameters.properties, "Update parameters.");
