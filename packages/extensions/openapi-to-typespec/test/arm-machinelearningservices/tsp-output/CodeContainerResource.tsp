import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Registry.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;
/**
 * Azure Resource Manager resource envelope.
 */
@parentResource(Registry)
model CodeContainerResource
  is Azure.ResourceManager.ProxyResource<CodeContainer, false> {
  ...ResourceNameParameter<
    Resource = CodeContainerResource,
    KeyName = "codeName",
    SegmentName = "codes",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;
}

alias CodeContainerResourceOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** Name of Azure Machine Learning registry. This is case-insensitive */
    @path
    @segment("registries")
    @key
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
    registryName: string;
  },
  {
    /** Container name. */
    @path
    @segment("codes")
    @key
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$")
    codeName: string;
  }
>;

@armResourceOperations
interface CodeContainerResources {
  /**
   * Get Code container.
   */
  get is CodeContainerResourceOps.Read<CodeContainerResource>;

  /**
   * Create or update Code container.
   */
  createOrUpdate is CodeContainerResourceOps.CreateOrUpdateAsync<CodeContainerResource>;

  /**
   * Delete Code container.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is CodeContainerResourceOps.DeleteWithoutOkAsync<
    CodeContainerResource,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List containers.
   */
  list is CodeContainerResourceOps.List<
    CodeContainerResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    Response = ArmResponse<CodeContainerResourceArmPaginatedResult>
  >;
}
alias CodeContainerOps = Azure.ResourceManager.Legacy.LegacyOperations<
  {
    ...ApiVersionParameter;
    ...SubscriptionIdParameter;
    ...ResourceGroupParameter;
    ...Azure.ResourceManager.Legacy.Provider;

    /** Name of Azure Machine Learning workspace. */
    @path
    @segment("workspaces")
    @key
    @pattern("^[a-zA-Z0-9][a-zA-Z0-9_-]{2,32}$")
    workspaceName: string;
  },
  {
    /** Container name. This is case-sensitive. */
    @path
    @segment("codes")
    @key
    name: string;
  }
>;

@armResourceOperations
interface CodeContainers {
  /**
   * Get container.
   */
  get is CodeContainerOps.Read<CodeContainerResource>;

  /**
   * Create or update container.
   */
  createOrUpdate is CodeContainerOps.CreateOrUpdateSync<CodeContainerResource>;

  /**
   * Delete container.
   */
  delete is CodeContainerOps.DeleteSync<CodeContainerResource>;

  /**
   * List containers.
   */
  list is CodeContainerOps.List<
    CodeContainerResource,
    Parameters = {
      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    },
    Response = ArmResponse<CodeContainerResourceArmPaginatedResult>
  >;
}

@@doc(CodeContainerResource.name, "Container name.");
@@doc(CodeContainerResource.properties,
  "[Required] Additional attributes of the entity."
);
@@doc(CodeContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
@@doc(CodeContainers.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
