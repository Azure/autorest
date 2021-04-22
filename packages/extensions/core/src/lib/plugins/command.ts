import { PipelinePlugin } from "../pipeline/common";
import { AutorestContext } from "../context";
import { DataSource, DataSink, DataHandle, QuickDataSource } from "@azure-tools/datastore";
import { execute, cmdlineToArray } from "@azure-tools/codegen";
import { FileUriToPath } from "@azure-tools/uri";

async function command(context: AutorestContext, input: DataSource, sink: DataSink) {
  const c = context.config.raw.run;
  const commands = Array.isArray(c) ? c : [c];
  for (const cmd of commands) {
    const commandline = cmdlineToArray(cmd);
    await execute(FileUriToPath(context.config.outputFolderUri), commandline[0], ...commandline.slice(1));
  }
  return new QuickDataSource([], input.pipeState);
}

/* @internal */
export function createCommandPlugin(): PipelinePlugin {
  return command;
}
