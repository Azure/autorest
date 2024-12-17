import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./TableServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * Properties of the table, including Id, resource name, resource type.
 */
@parentResource(TableServiceProperties)
model Table is Azure.ResourceManager.ProxyResource<TableProperties> {
  ...ResourceNameParameter<
    Resource = Table,
    KeyName = "tableName",
    SegmentName = "tables",
    NamePattern = "^[A-Za-z][A-Za-z0-9]{2,62}$"
  >;
}

@armResourceOperations
interface Tables {
  /**
   * Gets the table with the specified table name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Table_Get")
  get is ArmResourceRead<Table>;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes" "For backward compatibility"
  @operationId("Table_Create")
  create is ArmResourceCreateOrReplaceSync<
    Table,
    Response = ArmResourceUpdatedResponse<Table>
  >;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @parameterVisibility
  @operationId("Table_Update")
  update is ArmCustomPatchSync<Table, PatchModel = Table>;

  /**
   * Deletes the table with the specified table name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  #suppress "@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes" "For backward compatibility"
  @operationId("Table_Delete")
  delete is ArmResourceDeleteSync<
    Table,
    Response = ArmDeletedNoContentResponse
  >;

  /**
   * Gets a list of all the tables under the specified storage account
   */
  #suppress "@azure-tools/typespec-azure-core/no-openapi" "non-standard operations"
  @operationId("Table_List")
  list is ArmResourceListByParent<
    Table,
    Response = ArmResponse<ListTableResource>
  >;
}

@@maxLength(Table.name, 63);
@@minLength(Table.name, 3);
@@doc(Table.name,
  "A table name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of only alphanumeric characters and it cannot begin with a numeric character."
);
@@doc(Table.properties, "Table resource properties.");
@@doc(Tables.create::parameters.resource,
  "The parameters to provide to create a table."
);
@@doc(Tables.update::parameters.properties,
  "The parameters to provide to create a table."
);
