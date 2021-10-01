import { IAutorestLogger } from "@autorest/common";
import { DataHandle, indexToPosition } from "@azure-tools/datastore";
import { validateJson } from "@azure-tools/json";

/**
 * If a JSON file is provided, it checks that the syntax is correct.
 * And if the syntax is incorrect, it puts an error message .
 */
export async function checkSyntaxFromData(fileUri: string, handle: DataHandle, logger: IAutorestLogger): Promise<void> {
  if (fileUri.toLowerCase().endsWith(".json")) {
    const error = validateJson(await handle.readData());
    if (error) {
      logger.trackError({
        code: "JsonSpec/SyntaxError",
        message: `Syntax Error Encountered:  ${error.message}`,
        source: [{ position: await indexToPosition(handle, error.position), document: handle.key }],
      });
    }
  }
}
