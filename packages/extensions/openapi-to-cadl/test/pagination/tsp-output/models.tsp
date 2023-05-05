import "@typespec/rest";
import "@typespec/http";
import "@azure-tools/typespec-azure-core";

using TypeSpec.Rest;
using TypeSpec.Http;
using Azure.Core;

namespace AutoRestPagingTestService;

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
  @projectedName("json", "odata.nextLink")
  odataNextLink?: string;
}

@pagedResult
model ProductResultValueWithXMSClientName {
  @items
  @projectedName("json", "values")
  indexes?: Product[];

  @nextLink
  nextLink?: string;
}

model OperationResult {
  @doc("The status of the request")
  status?: OperationResultStatus;
}
