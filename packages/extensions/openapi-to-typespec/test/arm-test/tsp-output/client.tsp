import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Test;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(EmployeeUpdate.properties);
