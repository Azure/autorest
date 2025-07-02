import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Test;

@@clientLocation(ArrayDefaults.get, "ArrayDefault");
@@clientLocation(ArrayDefaults.listByResourceGroup, "ArrayDefault");
