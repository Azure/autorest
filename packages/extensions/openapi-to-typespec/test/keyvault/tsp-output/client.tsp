import "./main.tsp";
import "@typespec/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Azure.Keyvault;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(RoleDefinition.properties);
