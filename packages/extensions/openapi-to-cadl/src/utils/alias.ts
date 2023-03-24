import { CadlAlias, CadlObject } from "../interfaces";

export function addCorePageAlias(cadlObject: CadlObject): CadlAlias | undefined {
  if (!cadlObject.decorators?.some((d) => d.name === "pagedResult")) {
    return;
  }
  const value = cadlObject.properties.filter((p) => p.name === "value");
  if (!cadlObject.properties.some((p) => p.name === "nextLink") || !value.length) {
    return;
  }

  cadlObject.decorators = cadlObject.decorators.filter((d) => d.name !== "pagedResult");
  cadlObject.properties = cadlObject.properties.filter((p) => p.name !== "nextLink" && p.name !== "value");

  cadlObject.alias = {
    alias: "Azure.Core.Page",
    params: [value[0].type.replace("[]", "")],
    module: "@azure-tools/typespec-azure-core",
  };

  return;
}
