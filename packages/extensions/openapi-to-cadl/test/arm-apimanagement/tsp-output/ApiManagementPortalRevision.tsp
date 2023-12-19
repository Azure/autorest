import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementService.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.ApiManagement;
@doc("Portal Revision's contract details.")
@parentResource(ApiManagementService)
model ApiManagementPortalRevision
  is ProxyResource<PortalRevisionContractProperties> {
  @doc("Portal revision identifier. Must be unique in the current API Management service instance.")
  @maxLength(256)
  @minLength(1)
  @path
  @key("portalRevisionId")
  @segment("portalRevisions")
  name: string;
}

@armResourceOperations
interface ApiManagementPortalRevisions {
  @doc("Gets the developer portal's revision specified by its identifier.")
  get is ArmResourceRead<ApiManagementPortalRevision>;
  @doc("Gets the developer portal revision specified by its identifier.")
  @head
  getEntityTag(
    ...ResourceInstanceParameters<
      ApiManagementPortalRevision,
      BaseParameters<ApiManagementPortalRevision>
    >,
  ): OkResponse | ErrorResponse;
  @doc("Creates a new developer portal's revision by running the portal's publishing. The `isCurrent` property indicates if the revision is publicly accessible.")
  createOrUpdate is ArmResourceCreateOrUpdateAsync<ApiManagementPortalRevision>;
  @doc("Updates the description of specified portal revision or makes it current.")
  update is ArmResourcePatchAsync<
    ApiManagementPortalRevision,
    PortalRevisionContractProperties,
    {
      ...BaseParameters<ApiManagementPortalRevision>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;
  @doc("Lists developer portal's revisions.")
  listByService is ArmResourceListByParent<
    ApiManagementPortalRevision,
    {
      ...BaseParameters<ApiManagementPortalRevision>;

      @doc("""
| Field       | Supported operators    | Supported functions               |
|-------------|------------------------|-----------------------------------|

|name | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
|description | ge, le, eq, ne, gt, lt | substringof, contains, startswith, endswith|
|isCurrent | eq, ne |    |

""")
      @query("$filter")
      $filter?: string;

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
