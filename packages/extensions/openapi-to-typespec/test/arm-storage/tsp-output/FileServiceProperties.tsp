import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./StorageAccount.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * The properties of File services in storage account.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("default")
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  FileServicePropertiesProperties
)
model FileServiceProperties extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = FileServiceProperties,
    KeyName = "fileService",
    SegmentName = "fileServices",
    NamePattern = ""
  >;

  /**
   * The properties of File services in storage account.
   */
  @extension("x-ms-client-flatten", true)
  properties?: FileServicePropertiesProperties;

  ...Azure.ResourceManager.ResourceSkuProperty;
}

@armResourceOperations
interface FileServicePropertiesOperationGroup {
  /**
   * Gets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<FileServiceProperties>;

  /**
   * Sets the properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<FileServiceProperties>;

  /**
   * List all file services in storage accounts
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("FileServices_List")
  list is ArmResourceListByParent<FileServiceProperties>;
}

@@doc(FileServiceProperties.name, "");
@@encodedName(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(FileServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of file services in storage accounts, including CORS (Cross-Origin Resource Sharing) rules."
);
