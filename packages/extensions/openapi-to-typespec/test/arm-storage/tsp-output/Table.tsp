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
@doc("Properties of the table, including Id, resource name, resource type.")
@parentResource(TableServiceProperties)
model Table is ProxyResource<TableProperties> {
  @doc("A table name must be unique within a storage account and must be between 3 and 63 characters.The name must comprise of only alphanumeric characters and it cannot begin with a numeric character.")
  @maxLength(63)
  @minLength(3)
  @pattern("^[A-Za-z][A-Za-z0-9]{2,62}$")
  @path
  @key("tableName")
  @segment("tables")
  name: string;
}

@armResourceOperations
interface Tables {
  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets the table with the specified table name, under the specified account if it exists.")
  @operationId("Table_Get")
  get is ArmResourceRead<Table>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new table with the specified table name, under the specified account.")
  @operationId("Table_Create")
  create is ArmResourceCreateOrReplaceSync<Table>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Creates a new table with the specified table name, under the specified account.")
  @operationId("Table_Update")
  update is ArmCustomPatchSync<Table, Table>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Deletes the table with the specified table name, under the specified account if it exists.")
  @operationId("Table_Delete")
  delete is ArmResourceDeleteSync<Table>;

  #suppress "@azure-tools/typespec-azure-core/no-operation-id" "For backward compatibility"
  @doc("Gets a list of all the tables under the specified storage account")
  @operationId("Table_List")
  list is ArmResourceListByParent<Table>;
}
