import { dirname, join } from "path";
import { ArmCodeModel } from "main";
import { getSession } from "../autorest-session";
import { ArmResourceObjectSchema, InternalArmResource } from "../interfaces";

export function preTransformArmResources(codeModel: ArmCodeModel) {
  const session = getSession();
  const configPath: string = session.configuration.configFileFolderUri;
  const configFiles: string[] = session.configuration.configurationFiles;

  const localConfigFolder = dirname(configFiles.find((c) => c.startsWith(configPath)) ?? "").replace("file://", "");

  const { Resources } = require(join(localConfigFolder, "resources.json"));

  const resources: InternalArmResource[] = [];

  for (const resource in Resources) {
    resources.push(Resources[resource]);
  }

  codeModel.armResources = resources;
  const objectSchemas: ArmResourceObjectSchema[] = codeModel.schemas.objects ?? [];
  for (const schema of objectSchemas) {
    const resourceInfo = resources.find((r) => r.SwaggerModelName === schema.language.default.name);
    schema.resourceInformation = resourceInfo;
  }
}
