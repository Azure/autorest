import { ConvertOAI2toOAI3 } from '../../openapi/conversion';
import { CreatePerFilePlugin, PipelinePlugin } from '../common';

/* @internal */
export function GetPlugin_OAI2toOAIx(): PipelinePlugin {
  return CreatePerFilePlugin(async () => async (fileIn, sink) => {
    const fileOut = await ConvertOAI2toOAI3(fileIn, sink);
    return sink.Forward(fileIn.Description, fileOut);
  });
}
