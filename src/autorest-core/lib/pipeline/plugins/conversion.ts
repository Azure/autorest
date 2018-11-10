import { convertOAI2toOAI3 } from '../../openapi/conversion';
import { createPerFilePlugin, PipelinePlugin } from '../common';

/* @internal */
export function createSwaggerToOpenApi3Plugin(): PipelinePlugin {
  return createPerFilePlugin(async () => async (fileIn, sink) => {
    const fileOut = await convertOAI2toOAI3(fileIn, sink);
    return sink.Forward(fileIn.Description, fileOut);
  });
}
