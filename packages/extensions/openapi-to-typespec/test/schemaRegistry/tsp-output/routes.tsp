import "@azure-tools/typespec-azure-core";
import "@typespec/rest";
import "./models.tsp";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

/**
 * Gets the list of schema groups user is authorized to access.
 */
@summary("Get list of schema groups.")
op listSchemaGroups is Azure.Core.ResourceList<string>;

/**
 * Gets the properties referencing an existing schema within the specified schema
 * group, as matched by schema content comparison.
 */
@summary("Get properties for existing schema.")
@route("/$schemaGroups/{groupName}/schemas/{schemaName}:get-id")
@post
op getSchemaPropertiesByContent is Azure.Core.Foundations.Operation<
  {
    /**
     * Name of schema group.
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
     * String representation (UTF-8) of the schema.
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
 */
@summary("Register new schema")
@route("/$schemaGroups/{groupName}/schemas/{schemaName}")
@put
op registerSchema is Azure.Core.Foundations.Operation<
  {
    /**
     * Name of schema group.
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
     * String representation (UTF-8) of the schema.
     */
    @body
    schemaContent: bytes;
  },
  void
>;

/**
 * Gets the list of all versions of one schema.
 */
@summary("List schema versions.")
op listSchemaVersions is Azure.Core.ResourceList<int32>;

/**
 * Gets one specific version of one schema.
 */
@summary("Get specific schema versions.")
@route("/$schemaGroups/{groupName}/schemas/{schemaName}/versions/{schemaVersion}")
@get
op getSchemaByVersion is Azure.Core.Foundations.Operation<
  {
    /**
     * Name of schema group.
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

    /**
     * Accept header
     */
    @header
    accept: "application/json; serialization=Avro, application/json";
  },
  void
>;

/**
 * Gets a registered schema by its unique ID.  Azure Schema Registry guarantees
 * that ID is unique within a namespace. Operation response type is based on
 * serialization of schema requested.
 */
@summary("Get a registered schema by its unique ID reference.")
@route("/$schemaGroups/$schemas/{id}")
@get
op getSchemaById is Azure.Core.Foundations.Operation<
  {
    /**
     * Schema ID that uniquely identifies a schema in the registry namespace.
     */
    @path
    id: string;

    /**
     * Accept header
     */
    @header
    accept: "application/json; serialization=Avro, application/json";
  },
  void
>;
