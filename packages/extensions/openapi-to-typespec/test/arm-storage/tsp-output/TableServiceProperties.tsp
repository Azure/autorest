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
 * The properties of a storage account’s Table service.
 */
@parentResource(StorageAccount)
model TableServiceProperties
  is Azure.ResourceManager.ProxyResource<TableServicePropertiesProperties> {
  ...ResourceNameParameter<
    Resource = TableServiceProperties,
    KeyName = "tableServiceName",
    SegmentName = "tableServices",
    NamePattern = "",
    Type = "default"
  >;
}

@armResourceOperations
interface TableServicePropertiesOperationGroup {
  /**
   * Gets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TableServices_GetServiceProperties")
  getServiceProperties is ArmResourceRead<TableServiceProperties>;

  /**
   * Sets the properties of a storage account’s Table service, including properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TableServices_SetServiceProperties")
  setServiceProperties is ArmResourceCreateOrReplaceSync<TableServiceProperties>;

  /**
   * List all table services for the storage account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("TableServices_List")
  list is ArmResourceListByParent<TableServiceProperties>;
}

@@doc(TableServiceProperties.name,
  "The name of the Table Service within the specified storage account. Table Service Name must be 'default'"
);
@@doc(TableServiceProperties.properties,
  "The properties of a storage account’s Table service."
);
@@encodedName(TableServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(TableServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(TableServicePropertiesOperationGroup.setServiceProperties::parameters.resource,
  "The properties of a storage account’s Table service, only properties for Storage Analytics and CORS (Cross-Origin Resource Sharing) rules can be specified."
);
