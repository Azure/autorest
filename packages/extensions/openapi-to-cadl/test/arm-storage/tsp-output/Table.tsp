import "@azure-tools/typespec-azure-core";
import "@azure-tools/typespec-azure-resource-manager";
import "@typespec/rest";
import "./models.tsp";
import "./TableServiceProperty.tsp";

using TypeSpec.Rest;
using Azure.ResourceManager;
using Azure.ResourceManager.Foundations;
using TypeSpec.Http;

namespace Azure.ResourceManager.Storage;
@doc("Properties of the table, including Id, resource name, resource type.")
@parentResource(TableServiceProperty)
model Table is ProxyResource<TableProperties> {
  @doc("""
A table name must be unique within a storage account and must be between 3 and
63 characters.The name must comprise of only alphanumeric characters and it
cannot begin with a numeric character.
""")
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
  @doc("""
Gets the table with the specified table name, under the specified account if it
exists.
""")
  get is ArmResourceRead<Table>;
  @doc("Creates a new table with the specified table name, under the specified account.")
  create is ArmResourceCreateOrUpdateAsync<Table>;
  @doc("Creates a new table with the specified table name, under the specified account.")
  update is ArmResourcePatchSync<Table, TableProperties>;
  @doc("""
Deletes the table with the specified table name, under the specified account if
it exists.
""")
  delete is ArmResourceDeleteWithoutOkAsync<Table>;
  @doc("Gets a list of all the tables under the specified storage account")
  list is ArmResourceListByParent<Table>;
}
