import "./main.tsp";

using AzureSchemaRegistry;

@@clientLocation(SchemaGroupsOperationGroup.list, "SchemaGroups");

@@clientLocation(SchemaOperationGroup.getById, "Schema");
@@clientLocation(SchemaOperationGroup.getVersions, "Schema");
@@clientLocation(SchemaOperationGroup.getSchemaVersion, "Schema");
@@clientLocation(SchemaOperationGroup.queryIdByContent, "Schema");
@@clientLocation(SchemaOperationGroup.register, "Schema");
