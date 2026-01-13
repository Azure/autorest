import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./Factory.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.DataFactory;
/**
 * Global parameters resource type.
 */
@parentResource(Factory)
model GlobalParameterResource
  is Azure.ResourceManager.ProxyResource<Record<unknown>> {
  ...ResourceNameParameter<
    Resource = GlobalParameterResource,
    KeyName = "globalParameterName",
    SegmentName = "globalParameters",
    NamePattern = "^[A-Za-z0-9_][^<>*#.%&:\\\\+?/]*$"
  >;
  ...Azure.ResourceManager.Legacy.EntityTagProperty;
}

@armResourceOperations
interface GlobalParameterResources {
  /**
   * Gets a Global parameter
   */
  get is ArmResourceRead<GlobalParameterResource>;

  /**
   * Creates or updates a Global parameter
   */
  createOrUpdate is ArmResourceCreateOrReplaceSync<
    GlobalParameterResource,
    Response = ArmResourceUpdatedResponse<GlobalParameterResource>
  >;

  /**
   * Deletes a Global parameter
   */
  delete is ArmResourceDeleteSync<GlobalParameterResource>;

  /**
   * Lists Global parameters
   */
  listByFactory is ArmResourceListByParent<
    GlobalParameterResource,
    Response = ArmResponse<GlobalParameterListResponse>
  >;
}

@@maxLength(GlobalParameterResource.name, 260);
@@minLength(GlobalParameterResource.name, 1);
@@doc(GlobalParameterResource.name, "The global parameter name.");
@@doc(GlobalParameterResource.properties,
  "Properties of the global parameter."
);
@@doc(GlobalParameterResources.createOrUpdate::parameters.resource,
  "Global parameter resource definition."
);
