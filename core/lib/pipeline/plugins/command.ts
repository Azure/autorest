import { PipelinePlugin } from '../common';
import { ConfigurationView } from '../../configuration';
import { DataSource, DataSink, DataHandle, QuickDataSource } from '@azure-tools/datastore';
import { execute, cmdlineToArray } from '@azure-tools/codegen';
import { FileUriToPath } from '@azure-tools/uri';

async function command(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const c = (<any>config.Raw).run;
  const commands = Array.isArray(c) ? c : [c];
  for (const cmd of commands) {
    const commandline = cmdlineToArray(cmd);
    await execute(FileUriToPath(config.OutputFolderUri), commandline[0], ...commandline.slice(1));
  }
  return new QuickDataSource([], input.pipeState);
}

/* @internal */
export function createCommandPlugin(): PipelinePlugin {
  return command;
}