import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

/**
 * Array received from the registry containing the list of schema groups.
 */
model SchemaGroups {
  /**
   * Array of schema groups.
   */
  schemaGroups?: string[];
}

/**
 * An error response returned from Azure Schema Registry service.
 */
@error
model Error {
  /**
   * Error response returned from Azure Schema Registry service.
   */
  error: ErrorDetail;
}

/**
 * Error response returned from Azure Schema Registry service.
 */
model ErrorDetail {
  /**
   * Type of error.
   */
  code: string;

  /**
   * Brief description of error.
   */
  message: string;

  /**
   * Error message details to help user understand/debug failure.
   */
  details?: ErrorDetail[];
}

/**
 * Array received from the registry containing the list of versions for specific
 * schema.
 */
model SchemaVersions {
  /**
   * Array of schema groups.
   */
  schemaVersions?: int32[];
}

/**
 * Object received from the registry containing schema identifiers.
 */
model SchemaId {
  /**
   * Schema ID that uniquely identifies a schema in the registry namespace.
   */
  id?: string;
}
