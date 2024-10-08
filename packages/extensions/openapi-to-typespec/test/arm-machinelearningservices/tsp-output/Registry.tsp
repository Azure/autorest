import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Azure.ResourceManager.MachineLearning;

model Registry
  is Azure.ResourceManager.TrackedResource<RegistryProperties, false> {
  ...ResourceNameParameter<
    Resource = Registry,
    KeyName = "registryName",
    SegmentName = "registries",
    NamePattern = "^[a-zA-Z0-9][a-zA-Z0-9\\-_]{2,32}$"
  >;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  kind?: string;

  ...Azure.ResourceManager.ManagedServiceIdentityProperty;
  ...Azure.ResourceManager.ResourceSkuProperty;
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
  createOrUpdate is ArmResourceCreateOrReplaceAsync<Registry>;

  /**
   * Update tags
   */
  @parameterVisibility
  update is ArmCustomPatchSync<Registry, PartialRegistryPartialTrackedResource>;

  /**
   * Delete registry
   */
  #suppress "deprecated" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  delete is ArmResourceDeleteAsync<Registry>;

  /**
   * List registries
   */
  list is ArmResourceListByParent<Registry>;

  /**
   * List registries by subscription
   */
  listBySubscription is ArmListBySubscription<Registry>;

  /**
   * Remove regions from registry
   */
  removeRegions is ArmResourceActionAsync<Registry, Registry, Registry>;
}

@@doc(Registry.name,
  "Name of Azure Machine Learning registry. This is case-insensitive"
);
@@doc(Registry.properties, "[Required] Additional attributes of the entity.");
@@doc(Registries.createOrUpdate::parameters.resource,
  "Details required to create the registry."
);
@@doc(Registries.update::parameters.properties,
  "Details required to create the registry."
);
@@doc(Registries.removeRegions::parameters.body,
  "Details required to create the registry."
);
