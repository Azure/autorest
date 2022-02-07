import { fileURLToPath } from "url";
import { writeFile } from "@azure-tools/async-io";
import { stringify } from "@azure-tools/yaml";
import { PipelinePlugin } from "../../pipeline/common";

export function createSaveInPlacePlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    const files = await input.enum();
    for (const file of files) {
      const dataHandle = await input.readStrict(file);
      const originalName = dataHandle.originalFullPath;
      let originalPath;
      try {
        originalPath = fileURLToPath(originalName);
      } catch (error) {
        context.trackError({
          code: "SaveInPlace/NonLocal",
          message: `Cannot apply changes to "${originalName}" as it is not a local path. This file will be ignored.`,
        });
        continue;
      }
      const data = await dataHandle.readObject();

      const isYaml = originalPath.endsWith(".yaml") || originalPath.endsWith(".yml");
      const content = isYaml ? stringify(data) : JSON.stringify(data, null, 2);

      await writeFile(originalPath, content);
    }
    return input;
  };
}
