import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AutoRestPagingTestService;

/**
 * The status of the request
 */
enum OperationResultStatus {
  Succeeded,
  Failed,
  canceled,
  Accepted,
  Creating,
  Created,
  Updating,
  Updated,
  Deleting,
  Deleted,
  OK,
}

model ProductResultValue is Azure.Core.Page<Product>;

model Product {
  properties?: ProductProperties;
}

model ProductProperties {
  id?: int32;
  name?: string;
}

@pagedResult
model ProductResult {
  @items
  values?: Product[];

  @nextLink
  nextLink?: string;
}

@pagedResult
model OdataProductResult {
  @items
  values?: Product[];

  @nextLink
  @encodedName("application/json", "odata.nextLink")
  odataNextLink?: string;
}

@pagedResult
model ProductResultValueWithXMSClientName {
  @items
  @encodedName("application/json", "values")
  indexes?: Product[];

  @nextLink
  nextLink?: string;
}

model OperationResult {
  /**
   * The status of the request
   */
  status?: OperationResultStatus;
}
