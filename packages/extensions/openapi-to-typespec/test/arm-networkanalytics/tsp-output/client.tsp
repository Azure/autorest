import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.NetworkAnalytics;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DataProductUpdate.properties);

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(DataTypeUpdate.properties);
