import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

interface SchemaGroupsOperations {
  /**
   * Gets the list of schema groups user is authorized to access.
   */
  @summary("Get list of schema groups.")
  @route("/$schemaGroups")
  @get
  list is Azure.Core.Foundations.Operation<{}, SchemaGroups>;
}

interface SchemaOperations {
  /**
   * Gets a registered schema by its unique ID.  Azure Schema Registry guarantees
   * that ID is unique within a namespace. Operation response type is based on
   * serialization of schema requested.
   */
  @summary("Get a registered schema by its unique ID reference.")
  @route("/$schemaGroups/$schemas/{id}")
  @get
  getById is Azure.Core.Foundations.Operation<
    {
      /**
       * References specific schema in registry namespace.
       */
      @path
      id: string;

      /**
       * Accept header
       */
      @header
      accept: "application/json; serialization=Avro";
    },
    void
  >;

  /**
   * Gets the list of all versions of one schema.
   */
  @summary("Get list schema versions.")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}/versions")
  @get
  getVersions is Azure.Core.Foundations.Operation<
    {
      /**
       * Schema group under which schema is registered.  Group's serialization type
       * should match the serialization type specified in the request.
       */
      @path
      groupName: string;

      /**
       * Name of schema.
       */
      @maxLength(50)
      @pattern("^[A-Za-z0-9][^\\\\/$:]*$")
      @path
      schemaName: string;
    },
    SchemaVersions
  >;

  /**
   * Gets one specific version of one schema.
   */
  @summary("Get specific schema versions.")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}/versions/{schemaVersion}")
  @get
  getSchemaVersion is Azure.Core.Foundations.Operation<
    {
      /**
       * Schema group under which schema is registered.  Group's serialization type
       * should match the serialization type specified in the request.
       */
      @path
      groupName: string;

      /**
       * Name of schema.
       */
      @maxLength(50)
      @pattern("^[A-Za-z0-9][^\\\\/$:]*$")
      @path
      schemaName: string;

      /**
       * Version number of specific schema.
       */
      @path
      schemaVersion: int32;
    },
    void
  >;

  /**
   * Gets the ID referencing an existing schema within the specified schema group,
   * as matched by schema content comparison.
   */
  @summary("Get ID for existing schema.")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}:get-id")
  @post
  queryIdByContent is Azure.Core.Foundations.Operation<
    {
      /**
       * Schema group under which schema is registered.  Group's serialization type
       * should match the serialization type specified in the request.
       */
      @path
      groupName: string;

      /**
       * Name of schema.
       */
      @maxLength(50)
      @pattern("^[A-Za-z0-9][^\\\\/$:]*$")
      @path
      schemaName: string;

      /**
       * String representation (UTF-8) of the registered schema.
       */
      @body
      schemaContent: bytes;
    },
    void
  >;

  /**
   * Register new schema. If schema of specified name does not exist in specified
   * group, schema is created at version 1. If schema of specified name exists
   * already in specified group, schema is created at latest version + 1.
   *
   */
  @summary("Register new schema")
  @route("/$schemaGroups/{groupName}/schemas/{schemaName}")
  @put
  register is Azure.Core.Foundations.Operation<
    {
      /**
       * Schema group under which schema should be registered.  Group's serialization
       * type should match the serialization type specified in the request.
       */
      @path
      groupName: string;

      /**
       * Name of schema.
       */
      @maxLength(50)
      @pattern("^[A-Za-z0-9][^\\\\/$:]*$")
      @path
      schemaName: string;

      /**
       * String representation (UTF-8) of the schema being registered.
       */
      @body
      schemaContent: bytes;
    },
    void
  >;
}
