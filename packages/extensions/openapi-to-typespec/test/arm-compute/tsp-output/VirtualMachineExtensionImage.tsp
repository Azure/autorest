import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Compute;
/**
 * Describes a Virtual Machine Extension Image.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@subscriptionResource
@parentResource(SubscriptionLocationResource)
@includeInapplicableMetadataInPayload(false)
model VirtualMachineExtensionImage extends Resource {
  ...ResourceNameParameter<
    Resource = VirtualMachineExtensionImage,
    KeyName = "version",
    SegmentName = "versions",
    NamePattern = ""
  >;

  /**
   * Describes the properties of a Virtual Machine Extension Image.
   */
  @extension("x-ms-client-flatten", true)
  properties?: VirtualMachineExtensionImageProperties;
}

@armResourceOperations
interface VirtualMachineExtensionImages {
  /**
   * Gets a virtual machine extension image.
   */
  get is ArmResourceRead<VirtualMachineExtensionImage>;

  /**
   * Gets a list of virtual machine extension image types.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("VirtualMachineExtensionImages_ListTypes")
  listTypes is ArmResourceListByParent<VirtualMachineExtensionImage>;
}

@@doc(VirtualMachineExtensionImage.name, "");
