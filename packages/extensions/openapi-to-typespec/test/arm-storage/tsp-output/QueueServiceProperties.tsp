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
@parentResource(StorageAccount)
model QueueServiceProperties
  is Azure.ResourceManager.ProxyResource<QueueServicePropertiesProperties> {
  ...ResourceNameParameter<
    Resource = QueueServiceProperties,
    KeyName = "queueServiceName",
    SegmentName = "queueServices",
    NamePattern = "",
    Type = "default"
  >;
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

@@doc(QueueServiceProperties.name,
  "The name of the Queue Service within the specified storage account. Queue Service Name must be 'default'"
);
@@doc(QueueServiceProperties.properties,
  "The properties of a storage account’s Queue service."
);
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
