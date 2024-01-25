import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(RegistryProperties)
model Registry extends TrackedResourceBase {
  /**
   * Name of Azure Machine Learning registry. This is case-insensitive
   */
  @pattern("^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$")
  @path
  @key("registryName")
  @segment("registries")
  @visibility("read")
  name: string;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  /**
   * [Required] Additional attributes of the entity.
   */
  @extension("x-ms-client-flatten", true)
  properties: RegistryProperties;

  ...Azure.ResourceManager.ManagedServiceIdentity;
  ...Azure.ResourceManager.ResourceSku;
}

@armResourceOperations
interface Registries {
  /**
   * Get registry
   */
  get is ArmResourceRead<Registry>;

  /**
   * Create or update registry
   */
  createOrUpdate is ArmResourceCreateOrReplaceAsync<
    Registry,
    BaseParameters<Registry>,
    ArmAsyncOperationHeader
  >;

  /**
   * Update tags
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<Registry, PartialRegistryPartialTrackedResource>;

  /**
   * Delete registry
   */
  delete is ArmResourceDeleteAsync<
    Registry,
    BaseParameters<Registry>,
    ArmLroLocationHeader
  >;

  /**
   * List registries
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Registries_List")
  list is ArmResourceListByParent<Registry>;

  /**
   * List registries by subscription
   */
  listBySubscription is ArmListBySubscription<Registry>;

  /**
   * Remove regions from registry
   */
  removeRegions is ArmResourceActionAsync<
    Registry,
    Registry,
    Registry,
    BaseParameters<Registry>,
    ArmLroLocationHeader
  >;
}

@@projectedName(Registries.createOrUpdate::parameters.resource, "json", "body");
@@extension(Registries.createOrUpdate::parameters.resource,
  "x-ms-client-name",
  "body"
);
@@doc(Registries.createOrUpdate::parameters.resource,
  "Details required to create the registry."
);
@@projectedName(Registries.update::parameters.properties, "json", "body");
@@extension(Registries.update::parameters.properties,
  "x-ms-client-name",
  "body"
);
@@doc(Registries.update::parameters.properties,
  "Details required to create the registry."
);
@@doc(Registries.removeRegions::parameters.body,
  "Details required to create the registry."
);
