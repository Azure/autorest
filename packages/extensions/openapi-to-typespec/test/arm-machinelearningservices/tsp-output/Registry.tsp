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
  ...Azure.ResourceManager.ManagedServiceIdentityProperty;

  /**
   * Metadata used by portal/tooling/etc to render different UX experiences for resources of the same type.
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
  kind?: string;

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
  @patch(#{ implicitOptionality: false })
  update is ArmCustomPatchSync<
    Registry,
    PatchModel = PartialRegistryPartialTrackedResource
  >;

  /**
   * Delete registry
   */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  delete is ArmResourceDeleteWithoutOkAsync<
    Registry,
    Response = ArmDeletedResponse | ArmDeleteAcceptedLroResponse | ArmDeletedNoContentResponse
  >;

  /**
   * List registries
   */
  list is ArmResourceListByParent<
    Registry,
    Response = ArmResponse<RegistryTrackedResourceArmPaginatedResult>
  >;

  /**
   * List registries by subscription
   */
  listBySubscription is ArmListBySubscription<
    Registry,
    Response = ArmResponse<RegistryTrackedResourceArmPaginatedResult>
  >;

  /**
   * Remove regions from registry
   */
  removeRegions is ArmResourceActionAsync<
    Registry,
    Registry,
    ArmResponse<Registry>
  >;
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
