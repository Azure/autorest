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
 * The properties of a storage account’s Queue service.
 */
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@singleton("default")
@parentResource(StorageAccount)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(
  QueueServicePropertiesProperties
)
model QueueServiceProperties extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = QueueServiceProperties,
    KeyName = "queueService",
    SegmentName = "queueServices",
    NamePattern = ""
  >;

  /**
   * The properties of a storage account’s Queue service.
   */
  @extension("x-ms-client-flatten", true)
  properties?: QueueServicePropertiesProperties;
}

@armResourceOperations
interface QueueServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("QueueServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<QueueServiceProperties>;

  /**
   * Sets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("QueueServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<QueueServiceProperties>;

  /**
   * List all queue services for the storage account
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("QueueServices_List")
  list is ArmResourceListByParent<QueueServiceProperties>;
}

@@doc(QueueServiceProperties.name, "");
@@encodedName(QueueServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(QueueServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(QueueServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Queue service, only properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules can be specified."
);
