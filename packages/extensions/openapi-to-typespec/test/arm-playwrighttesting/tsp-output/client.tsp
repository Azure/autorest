import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using Microsoft.AzurePlaywrightService;

@@clientName(Accounts.createOrUpdate, "CreateOrUpdate");
@@clientName(Accounts.listByResourceGroup, "ListByResourceGroup");
@@clientName(Accounts.listBySubscription, "ListBySubscription");

@@clientName(Quotas.listBySubscription, "ListBySubscription");
