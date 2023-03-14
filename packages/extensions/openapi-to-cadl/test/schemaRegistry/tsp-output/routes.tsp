import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

interface SchemaGroupsOperations {
  @summary("Get list of schema groups.")
  @doc("Gets the list of schema groups user is authorized to access.")
  @route("/$schemaGroups")
  @get
  List is Azure.Core.Foundations.Operation<{}, SchemaGroups>;
}

interface SchemaOperations {
  @summary("Get a registered schema by its unique ID reference.")
  @doc("""
Gets a registered schema by its unique ID.  Azure Schema Registry guarantees
that ID is unique within a namespace. Operation response type is based on
serialization of schema requested.
""")
  @route("/$schemaGroups/$schemas/{id}")
  @get
  GetById is Azure.Core.Foundations.Operation<
    {
      @doc("References specific schema in registry namespace.")
      @path
      id: string;

      @doc("Accept header")
      @header
      Accept: "application/json; serialization=Avro";
    },
    void
  >;

  @summary("Get list schema versions.")
  @doc("Gets the list of all versions of one schema.")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}/versions")
  @get
  GetVersions is Azure.Core.Foundations.Operation<
    {
      @doc("""
Schema group under which schema is registered.  Group's serialization type
should match the serialization type specified in the request.
""")
      @path
      groupName: string;

      @doc("Name of schema.")
      @path
      schemaName: string;
    },
    SchemaVersions
  >;

  @summary("Get specific schema versions.")
  @doc("Gets one specific version of one schema.")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}/versions/{schemaVersion}")
  @get
  GetSchemaVersion is Azure.Core.Foundations.Operation<
    {
      @doc("""
Schema group under which schema is registered.  Group's serialization type
should match the serialization type specified in the request.
""")
      @path
      groupName: string;

      @doc("Name of schema.")
      @path
      schemaName: string;

      @doc("Version number of specific schema.")
      @path
      schemaVersion: int32;
    },
    void
  >;

  @summary("Get ID for existing schema.")
  @doc("""
Gets the ID referencing an existing schema within the specified schema group,
as matched by schema content comparison.
""")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}:get-id")
  @post
  QueryIdByContent is Azure.Core.Foundations.Operation<
    {
      @doc("""
Schema group under which schema is registered.  Group's serialization type
should match the serialization type specified in the request.
""")
      @path
      groupName: string;

      @doc("Name of schema.")
      @path
      schemaName: string;

      @doc("String representation (UTF-8) of the registered schema.")
      @body
      schemaContent: bytes;
    },
    void
  >;

  @summary("Register new schema")
  @doc("""
Register new schema. If schema of specified name does not exist in specified
group, schema is created at version 1. If schema of specified name exists
already in specified group, schema is created at latest version + 1.

""")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}")
  @put
  Register is Azure.Core.Foundations.Operation<
    {
      @doc("""
Schema group under which schema should be registered.  Group's serialization
type should match the serialization type specified in the request.
""")
      @path
      groupName: string;

      @doc("Name of schema.")
      @path
      schemaName: string;

      @doc("String representation (UTF-8) of the schema being registered.")
      @body
      schemaContent: bytes;
    },
    void
  >;
}
