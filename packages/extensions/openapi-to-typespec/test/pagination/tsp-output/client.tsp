import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AutoRestPagingTestService;

@@clientName(OdataProductResult.`odata.nextLink`, "odataNextLink");

@@clientName(ProductResultValueWithXMSClientName.values, "indexes");
