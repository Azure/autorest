import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/openapi";
import "@typespec/rest";
import "./models.tsp";
import "./TableServiceProperties.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;
using TypeSpec.OpenAPI;

namespace Microsoft.Storage;
/**
 * Properties of the table, including Id, resource name, resource type.
 */
@parentResource(TableServiceProperties)
model Table is ProxyResource<TableProperties> {
  /**
   * A table name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of only alphanumeric characters and it cannot begin with a numeric character.
   */
  @maxLength(63)
  @minLength(3)
  @pattern("^[A-Za-z][A-Za-z0-9]{2,62}$")
  @path
  @key("tableName")
  @segment("tables")
  @visibility("read")
  name: string;
}

@armResourceOperations
interface Tables {
  /**
   * Gets the table with the specified table name, under the specified account if it exists.
   */
  get is ArmResourceRead<Table>;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  create is ArmResourceCreateOrReplaceSync<Table>;

  /**
   * Creates a new table with the specified table name, under the specified account.
   */
  @parameterVisibility("read")
  update is ArmCustomPatchSync<Table, Table>;

  /**
   * Deletes the table with the specified table name, under the specified account if it exists.
   */
  delete is ArmResourceDeleteSync<Table>;

  /**
   * Gets a list of all the tables under the specified storage account
   */
  list is ArmResourceListByParent<Table>;
}

@@doc(Tables.create::parameters.resource,
  "The parameters to provide to create a table."
);
@@doc(Tables.update::parameters.properties,
  "The parameters to provide to create a table."
);
