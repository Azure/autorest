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
@Azure.ResourceManager.Private.armResourceInternal(CodeContainer)
model CodeContainerResource extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = CodeContainerResource,
    KeyName = "codeName",
    SegmentName = "codes",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{0,254}$"
  >;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: CodeContainer;
}

@armResourceOperations
interface CodeContainerResources {
  /**
   * Get Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_Get")
  get is ArmResourceRead<CodeContainerResource>;

  /**
   * Create or update Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_CreateOrUpdate")
  createOrUpdate is ArmResourceCreateOrReplaceAsync<CodeContainerResource>;

  /**
   * Delete Code container.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("RegistryCodeContainers_Delete")
  delete is ArmResourceDeleteAsync<CodeContainerResource>;

  /**
   * List containers.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("RegistryCodeContainers_List")
  list is ArmResourceListByParent<
    CodeContainerResource,
    {
      ...Azure.ResourceManager.Foundations.BaseParameters<CodeContainerResource>;

      /**
       * Continuation token for pagination.
       */
      @query("$skip")
      $skip?: string;
    }
  >;
}

@@doc(CodeContainerResource.name, "Container name.");
@@encodedName(CodeContainerResources.createOrUpdate::parameters.resource,
  "application/json",
  "body"
);
@@extension(CodeContainerResources.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(CodeContainerResources.createOrUpdate::parameters.resource,
  "Container entity to create or update."
);
