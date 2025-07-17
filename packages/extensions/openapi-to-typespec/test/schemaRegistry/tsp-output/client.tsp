import "./main.tsp";
import "@azure-tools/typespec-client-generator-core";

using Azure.ClientGenerator.Core;
using AzureSchemaRegistry;

@@clientLocation(SchemaGroupsOperationGroup.list, "SchemaGroups");

@@clientLocation(SchemaOperationGroup.getById, "Schema");
@@clientName(SchemaOperationGroup.getById, "GetById");
@@clientLocation(SchemaOperationGroup.getVersions, "Schema");
@@clientName(SchemaOperationGroup.getVersions, "GetVersions");
@@clientLocation(SchemaOperationGroup.getSchemaVersion, "Schema");
@@clientName(SchemaOperationGroup.getSchemaVersion, "GetSchemaVersion");
@@clientLocation(SchemaOperationGroup.queryIdByContent, "Schema");
@@clientName(SchemaOperationGroup.queryIdByContent, "QueryIdByContent");
@@clientLocation(SchemaOperationGroup.register, "Schema");
