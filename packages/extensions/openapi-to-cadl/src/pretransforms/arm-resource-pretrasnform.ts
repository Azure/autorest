import { dirname, join } from "path";
import { ArmCodeModel } from "main";
import { getSession } from "../autorest-session";
import { ArmResourceObjectSchema, InternalArmResources } from "../interfaces";

export function preTransformArmResources(codeModel: ArmCodeModel) {
  const session = getSession();
  const configPath: string = session.configuration.configFileFolderUri;
  const configFiles: string[] = session.configuration.configurationFiles;

  const localConfigFolder = dirname(configFiles.find((c) => c.startsWith(configPath)) ?? "").replace("file://", "");

  const { Resources: resources }: InternalArmResources = require(join(localConfigFolder, "resources.json"));
  codeModel.armResources = resources;
  const objectSchemas: ArmResourceObjectSchema[] = codeModel.schemas.objects ?? [];
  for (const schema of objectSchemas) {
    const resourceInfo = resources.find((r) => r.ModelName === schema.language.default.name);
    schema.resourceInformation = resourceInfo;
  }
}
