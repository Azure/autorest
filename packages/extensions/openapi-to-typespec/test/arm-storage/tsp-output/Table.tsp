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
#suppress "@azure-tools/typespec-azure-core/composition-over-inheritance" "For backward compatibility"
#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-invalid-envelope-property" "For backward compatibility"
@parentResource(TableServiceProperties)
@includeInapplicableMetadataInPayload(false)
@Azure.ResourceManager.Private.armResourceInternal(TableProperties)
model Table extends Foundations.ProxyResource {
  ...ResourceNameParameter<
    Resource = Table,
    KeyName = "tableName",
    SegmentName = "tables",
    NamePattern = "^[A-Za-z][A-Za-z0-9]{2,62}$"
  >;

  /**
   * Table resource properties.
   */
  @extension("x-ms-client-flatten", true)
  properties?: TableProperties;
}

@armResourceOperations
interface Tables {
  /**
   * Gets the table with the specified table name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Table_Get")
  get is ArmResourceRead<Table>;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Table_Create")
  create is ArmResourceCreateOrReplaceSync<Table>;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @parameterVisibility
  @operationId("Table_Update")
  update is ArmCustomPatchSync<Table, Table>;

  /**
   * Deletes the table with the specified table name, under the specified account if it exists.
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  #suppress "@azure-tools/typespec-azure-core/no-response-body" "For backward compatibility"
  @operationId("Table_Delete")
  delete is ArmResourceDeleteSync<Table>;

  /**
   * Gets a list of all the tables under the specified storage account
   */
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @operationId("Table_List")
  list is ArmResourceListByParent<Table>;
}

@@maxLength(Table.name, 63);
@@minLength(Table.name, 3);
@@doc(Table.name,
  "A table name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of only alphanumeric characters and it cannot begin with a numeric character."
);
@@encodedName(Tables.create::parameters.resource,
  "application/json",
  "parameters"
);
@@extension(Tables.create::parameters.resource,
  "x-ms-client-name",
  "parameters"
);
@@doc(Tables.create::parameters.resource,
  "The parameters to provide to create a table."
);
@@encodedName(Tables.update::parameters.properties,
  "application/json",
  "parameters"
);
@@extension(Tables.update::parameters.properties,
  "x-ms-client-name",
  "parameters"
);
@@doc(Tables.update::parameters.properties,
  "The parameters to provide to create a table."
);
