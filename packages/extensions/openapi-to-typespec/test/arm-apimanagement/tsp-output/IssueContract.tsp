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
@doc("Issue Contract details.")
@parentResource(ApiContract)
model IssueContract is ProxyResource<IssueContractProperties> {
  @doc("Issue identifier. Must be unique in the current API Management service instance.")
  @maxLength(256)
  @minLength(1)
  @pattern("^[^*#&+:<>?]+$")
  @path
  @key("issueId")
  @segment("issues")
  name: string;
}

@armResourceOperations
interface IssueContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the details of the Issue for an API specified by its identifier.")
  @operationId("ApiIssue_Get")
  get is ArmResourceRead<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("Expand the comment attachments. ")
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the entity state (Etag) version of the Issue for an API specified by its identifier.")
  @head
  @operationId("ApiIssue_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<IssueContract, BaseParameters<IssueContract>>,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new Issue for an API or updates an existing one.")
  @operationId("ApiIssue_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. Not required when creating an entity, but required when updating an entity.")
      @header
      `If-Match`?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates an existing issue for an API.")
  @operationId("ApiIssue_Update")
  update is ArmCustomPatchSync<
    IssueContract,
    IssueUpdateContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the specified Issue from an API.")
  @operationId("ApiIssue_Delete")
  delete is ArmResourceDeleteSync<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists all issues associated with the specified API.")
  @operationId("ApiIssue_ListByService")
  listByService is ArmResourceListByParent<
    IssueContract,
    {
      ...BaseParameters<IssueContract>;

      @doc("|     Field     |     Usage     |     Supported operators     |     Supported functions     |</br>|-------------|-------------|-------------|-------------|</br>| name | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| userId | filter | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith |</br>| state | filter | eq |     |</br>")
      @query("$filter")
      $filter?: string;

      @doc("Expand the comment attachments. ")
      @query("expandCommentsAttachments")
      expandCommentsAttachments?: boolean;

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

@@projectedName(IssueContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(IssueContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueContracts.createOrUpdate::parameters.resource, "Create parameters.");
@@projectedName(IssueContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(IssueContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(IssueContracts.update::parameters.properties, "Update parameters.");
