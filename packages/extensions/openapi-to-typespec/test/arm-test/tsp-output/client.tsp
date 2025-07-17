import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.Test;

@@clientName(Employees.createOrUpdate, "CreateOrUpdate");
@@clientName(Employees.listByResourceGroup, "ListByResourceGroup");
@@clientName(Employees.listBySubscription, "ListBySubscription");

@@clientLocation(DictProperties.get, "DictProperties");
@@clientLocation(DictProperties.listByResourceGroup, "DictProperties");
@@clientName(DictProperties.listByResourceGroup, "ListByResourceGroup");

@@clientLocation(ArrayDefaults.get, "ArrayDefault");
@@clientLocation(ArrayDefaults.listByResourceGroup, "ArrayDefault");
@@clientName(ArrayDefaults.listByResourceGroup, "ListByResourceGroup");
