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
@doc("Tenant Settings.")
@parentResource(ApiManagementServiceResource)
model AccessInformationContract
  is ProxyResource<AccessInformationContractProperties> {
  @doc("The identifier of the Access configuration.")
  @path
  @key("accessName")
  @segment("tenant")
  name: AccessIdName;
}

@armResourceOperations
interface AccessInformationContracts {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get tenant access information details without secrets.")
  @operationId("TenantAccess_Get")
  get is ArmResourceRead<AccessInformationContract>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Tenant access metadata")
  @head
  @operationId("TenantAccess_GetEntityTag")
  getEntityTag(
    ...ResourceInstanceParameters<
      AccessInformationContract,
      BaseParameters<AccessInformationContract>
    >,
  ): OkResponse | ErrorResponse;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update tenant access information details.")
  @operationId("TenantAccess_Create")
  create is ArmResourceCreateOrReplaceSync<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Update tenant access information details.")
  @operationId("TenantAccess_Update")
  update is ArmCustomPatchSync<
    AccessInformationContract,
    AccessInformationUpdateParameters,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("ETag of the Entity. ETag should match the current entity state from the header response of the GET request or it should be * for unconditional update.")
      @header
      `If-Match`: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Returns list of access infos - for Git and Management endpoints.")
  @operationId("TenantAccess_ListByService")
  listByService is ArmResourceListByParent<
    AccessInformationContract,
    {
      ...BaseParameters<AccessInformationContract>;

      @doc("Not used")
      @query("$filter")
      $filter?: string;
    }
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerate primary access key")
  @operationId("TenantAccess_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerate secondary access key")
  @operationId("TenantAccess_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Get tenant access information details.")
  @operationId("TenantAccess_ListSecrets")
  listSecrets is ArmResourceActionSync<
    AccessInformationContract,
    void,
    AccessInformationSecretsContract
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerate primary access key for GIT.")
  @operationId("TenantAccessGit_RegeneratePrimaryKey")
  regeneratePrimaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Regenerate secondary access key for GIT.")
  @operationId("TenantAccessGit_RegenerateSecondaryKey")
  regenerateSecondaryKey is ArmResourceActionNoContentSync<
    AccessInformationContract,
    void
  >;
}

@@projectedName(AccessInformationContracts.create::parameters.resource,
  "json",
  "parameters"
);
@@extension(AccessInformationContracts.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.create::parameters.resource,
  "Parameters supplied to retrieve the Tenant Access Information."
);
@@projectedName(AccessInformationContracts.update::parameters.properties,
  "json",
  "parameters"
);
@@extension(AccessInformationContracts.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(AccessInformationContracts.update::parameters.properties,
  "Parameters supplied to retrieve the Tenant Access Information."
);
