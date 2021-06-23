import { Channel, SourceLocation } from "../../message";
import { DataHandle, indexToPosition, StrictJsonSyntaxCheck } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";

/**
 * If a JSON file is provided, it checks that the syntax is correct.
 * And if the syntax is incorrect, it puts an error message .
 */
export async function checkSyntaxFromData(
  fileUri: string,
  handle: DataHandle,
  configView: AutorestContext,
): Promise<void> {
  if (fileUri.toLowerCase().endsWith(".json")) {
    const error = StrictJsonSyntaxCheck(await handle.readData());
    if (error) {
      configView.Message({
        Channel: Channel.Error,
        Text: `Syntax Error Encountered:  ${error.message}`,
        Source: [<SourceLocation>{ Position: await indexToPosition(handle, error.index), document: handle.key }],
      });
    }
  }
}
