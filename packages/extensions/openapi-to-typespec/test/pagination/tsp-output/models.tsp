import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AutoRestPagingTestService;

/** The status of the request */
union OperationResultStatus {
  string,

  /** Succeeded */
  Succeeded: "Succeeded",

  /** Failed */
  Failed: "Failed",

  /** canceled */
  canceled: "canceled",

  /** Accepted */
  Accepted: "Accepted",

  /** Creating */
  Creating: "Creating",

  /** Created */
  Created: "Created",

  /** Updating */
  Updating: "Updating",

  /** Updated */
  Updated: "Updated",

  /** Deleting */
  Deleting: "Deleting",

  /** Deleted */
  Deleted: "Deleted",

  /** OK */
  OK: "OK",
}

model ProductResultValue is Azure.Core.Page<Product>;

model Product {
  properties?: ProductProperties;
}

model ProductProperties {
  id?: int32;
  name?: string;
}

model ProductResult {
  @pageItems
  values?: Product[];

  @nextLink
  nextLink?: string;
}

model OdataProductResult {
  @pageItems
  values?: Product[];

  @nextLink
  `odata.nextLink`?: string;
}

model ProductResultValueWithXMSClientName {
  @pageItems
  values?: Product[];

  @nextLink
  nextLink?: string;
}

model OperationResult {
  /** The status of the request */
  status?: OperationResultStatus;
}
