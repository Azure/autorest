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
/** The properties of a storage account’s Queue service. */
@singleton("default")
@parentResource(StorageAccount)
model QueueServiceProperties
  is Azure.ResourceManager.ProxyResource<QueueServicePropertiesProperties> {
  ...ResourceNameParameter<
    Resource = QueueServiceProperties,
    KeyName = "queueService",
    SegmentName = "queueServices",
    NamePattern = ""
  >;
}

@armResourceOperations
interface QueueServices {
  /** Gets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. */
  getServiceProperties is ArmResourceRead<QueueServiceProperties>;

  /** Sets the properties of a storage account’s Queue service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules. */
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  setServiceProperties is ArmResourceCreateOrReplaceSync<
    QueueServiceProperties,
    Response = ArmResourceUpdatedResponse<QueueServiceProperties>
  >;

  /** List all queue services for the storage account */
  list is ArmResourceListByParent<
    QueueServiceProperties,
    Response = ArmResponse<ListQueueServices>
  >;
}

@@doc(QueueServiceProperties.name, "");
@@doc(QueueServiceProperties.properties,
  "The properties of a storage account’s Queue service."
);
@@doc(QueueServices.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Queue service, only properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules can be specified."
);
