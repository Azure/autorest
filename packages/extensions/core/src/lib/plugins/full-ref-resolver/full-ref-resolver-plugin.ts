import { QuickDataSource } from "@azure-tools/datastore";
import { PipelinePlugin } from "../../pipeline/common";
import { FullRefResolver } from "./full-ref-resolver";

/**
 * Plugin expanding all the $ref to their absolute path.
 */
export function createFullRefResolverPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    const files = await input.enum();

    const results = await Promise.all(
      files.map(async (file) => {
        const dataHandle = await input.readStrict(file);
        const resolver = new FullRefResolver(dataHandle);
        const output = await resolver.getOutput();
        return sink.writeObject(dataHandle.description, output, dataHandle.identity, dataHandle.artifactType, {
          pathMappings: await resolver.getSourceMappings(),
        });
      }),
    );
    return new QuickDataSource(results);
  };
}
