import { TypespecAlias, TypespecObject } from "../interfaces";

export function addCorePageAlias(typespecObject: TypespecObject): TypespecAlias | undefined {
  if (!typespecObject.decorators?.some((d) => d.name === "pagedResult")) {
    return;
  }
  const value = typespecObject.properties.filter((p) => p.name === "value");
  if (!typespecObject.properties.some((p) => p.name === "nextLink") || !value.length) {
    return;
  }

  typespecObject.decorators = typespecObject.decorators.filter((d) => d.name !== "pagedResult");
  typespecObject.properties = typespecObject.properties.filter((p) => p.name !== "nextLink" && p.name !== "value");

  typespecObject.alias = {
    alias: "Azure.Core.Page",
    params: [value[0].type.replace("[]", "")],
    module: "@azure-tools/typespec-azure-core",
  };

  return;
}
