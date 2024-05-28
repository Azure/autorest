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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(Registry)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(EnvironmentContainer)
model EnvironmentContainerResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = EnvironmentContainerResource,
    KeyName = "environmentName",
    SegmentName = "environments",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: EnvironmentContainer;
}

@armResourceOperations
interface EnvironmentContainerResources {
  /**
   * Get container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentContainers_Get")
  get is ArmResourceRead<EnvironmentContainerResource>;

  /**
   * Create or update container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<EnvironmentContainerResource>;

  /**
   * Delete container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryEnvironmentContainers_Delete")
  delete is ArmResourceDeleteAsync<EnvironmentContainerResource>;

  /**
   * List environment containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryEnvironmentContainers_List")
  list is ArmResourceListByParent<
    EnvironmentContainerResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<EnvironmentContainerResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;

      /**
       * View type for including/excluding (for example) archived entities.
       */
      @query("listViewType")
      listViewType?: ListViewType;
    }
  >;
}

@@doc(EnvironmentContainerResource.name,
  "Container name. This is case-sensitive."
);
@@encodedName(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(EnvironmentContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
