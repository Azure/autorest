import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace AzureSchemaRegistry;

@doc("Array received from the registry containing the list of schema groups.")
model SchemaGroups {
  @doc("Array of schema groups.")
  schemaGroups?: string[];
}

@doc("An error response returned from Azure Schema Registry service.")
@error
model Error {
  @doc("Error response returned from Azure Schema Registry service.")
  error: ErrorDetail;
}

@doc("Error response returned from Azure Schema Registry service.")
model ErrorDetail {
  @doc("Type of error.")
  code: string;

  @doc("Brief description of error.")
  message: string;

  @doc("Error message details to help user understand/debug failure.")
  details?: ErrorDetail[];
}

@doc("""
Array received from the registry containing the list of versions for specific
schema.
""")
model SchemaVersions {
  @doc("Array of schema groups.")
  schemaVersions?: int32[];
}

@doc("Object received from the registry containing schema identifiers.")
model SchemaId {
  @doc("Schema ID that uniquely identifies a schema in the registry namespace.")
  id?: string;
}
