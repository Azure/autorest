import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Keyvault;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleDefinition.properties);
