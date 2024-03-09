import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.AzurePlaywrightService;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(AccountUpdate.properties);
