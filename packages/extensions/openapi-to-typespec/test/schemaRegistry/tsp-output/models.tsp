import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

/**
 * Represents the Schema Registry API version to use for requests.
 */
enum ServiceVersion {
  /**
   * Azure Schema Registry 2021-10 Version
   */
  V2021_10: "2021-10",

  /**
   * Azure Schema Registry 2022-10 Version
   */
  V2022_10: "2022-10",

  /**
   * Azure Schema Registry 2023-07-01 Version. This is the default version.
   */
  V2023_07_01: "2023-07-01",
}

/**
 * The list of schema group names with server paging support.
 */
model SchemaGroups is Azure.Core.Page<string>;

/**
 * A response containing error details.
 */
@error
model AzureCoreFoundationsErrorResponse {
  /**
   * The error object.
   */
  error: AzureCoreFoundationsError;
}

/**
 * The error object.
 */
model AzureCoreFoundationsError {
  /**
   * One of a server-defined set of error codes.
   */
  code: string;

  /**
   * A human-readable representation of the error.
   */
  message: string;

  /**
   * The target of the error.
   */
  target?: string;

  /**
   * An array of details about specific errors that led to this reported error.
   */
  details?: AzureCoreFoundationsError[];

  /**
   * An object containing more specific information than the current object about
   * the error.
   */
  innererror?: AzureCoreFoundationsInnerError;
}

/**
 * An object containing more specific information about the error. As per
 * Microsoft One API guidelines -
 * https://github.com/Microsoft/api-guidelines/blob/vNext/Guidelines.md#7102-error-condition-responses.
 */
model AzureCoreFoundationsInnerError {
  /**
   * One of a server-defined set of error codes.
   */
  code?: string;

  /**
   * Inner error.
   */
  innererror?: AzureCoreFoundationsInnerError;
}

/**
 * The list of schema versions with server paging support.
 */
model SchemaVersions is Azure.Core.Page<int32>;

/**
 * The schema, including its metadata and content.
 */
model Schema {
  /**
   * String representation (UTF-8) of the schema.
   */
  schemaContent: bytes;
}

/**
 * Schema Group resource.
 */
model SchemaGroup {
  /**
   * Name of schema group.
   */
  @visibility("read")
  groupName: string;
}

/**
 * Schemas resource.
 */
model SchemasName {
  /**
   * Name of schema.
   */
  @visibility("read")
  @maxLength(50)
  @pattern("^[A-Za-z0-9][^\\\\/$:]*$")
  schemaName: string;
}
