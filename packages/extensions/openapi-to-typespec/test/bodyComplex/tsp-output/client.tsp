import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AutoRestComplexTestService;

#suppress "deprecated" "@flattenProperty decorator is not recommended to use."
@@flattenProperty(MyBaseType.helper);
