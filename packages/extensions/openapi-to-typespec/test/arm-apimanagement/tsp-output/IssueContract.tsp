import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiContract.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
/**
 * Issue Contract details.
 */
@parentResource(ApiContract)
model IssueContract is ProxyResource<IssueContractProperties> {
  /**
   * Issue identifier. Must be unique in the current API Management service instance.
   */
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("issueId")
  @segment("issues")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface IssueContracts {
  /**
   * Gets the details of the Issue for an API specified by its identifier.
   */
  get is ArmResourceRead<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

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
  @head
  getEntityTag(
    ...ResourceInstanceParameters<IssueContract, BaseParameters<IssueContract>>,
  ): OkResponse | ErrorResponse;

  /**
   * Creates a new Issue for an API or updates an existing one.
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

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
  @parameterVisibility("read")
  update is ArmCustomPatchSync<
    IssueContract,
    IssueUpdateContract,
    {
      ...BaseParameters<IssueContract>;

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
  delete is ArmResourceDeleteSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

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
  listByService is ArmResourceListByParent<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

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

@@doc(IssueContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@doc(IssueContracts.update::parameters.properties, "Update parameters.");
