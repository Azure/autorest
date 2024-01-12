import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./ApiManagementServiceResource.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.ApiManagement;
@doc("Portal Revision's contract details.")
@parentResource(ApiManagementServiceResource)
model PortalRevisionContract
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
interface PortalRevisionContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the developer portal's revision specified by its identifier.")
  @operationId("PortalRevision_Get")
  get is ArmResourceRead<PortalRevisionContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the developer portal revision specified by its identifier.")
  @head
  @operationId("PortalRevision_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      PortalRevisionContract,
      BaseParameters<PortalRevisionContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new developer portal's revision by running the portal's publishing. The `isCurrent` property indicates if the revision is publicly accessible.")
  @operationId("PortalRevision_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    PortalRevisionContract,
    BaseParameters<PortalRevisionContract>,
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Updates the description of specified portal revision or makes it current.")
  @operationId("PortalRevision_Update")
  update is ArmCustomPatchAsync<
    PortalRevisionContract,
    PortalRevisionContract,
    {
      ...BaseParameters<PortalRevisionContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    },
    ArmLroLocationHeader
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Lists developer portal's revisions.")
  @operationId("PortalRevision_ListByService")
  listByService is ArmResourceListByParent<
    PortalRevisionContract,
    {
      ...BaseParameters<PortalRevisionContract>;

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

@@projectedName(PortalRevisionContracts.createOrUpdate::parameters.resource,
  "json",
  "parameters"
);
@@extension(PortalRevisionContracts.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalRevisionContracts.createOrUpdate::parameters.resource, "");
@@projectedName(PortalRevisionContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(PortalRevisionContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(PortalRevisionContracts.update::parameters.properties, "");
