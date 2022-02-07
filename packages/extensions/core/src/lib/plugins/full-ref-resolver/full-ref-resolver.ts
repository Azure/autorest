import { DataHandle, Node, Transformer } from "@azure-tools/datastore";
import { parseJsonRef } from "@azure-tools/jsonschema";
import { resolveUri } from "@azure-tools/uri";

export class FullRefResolver extends Transformer<any, any> {
  private originalFileLocation: string;

  constructor(originalFile: DataHandle) {
    super(originalFile);

    this.originalFileLocation = resolveUri(originalFile.originalDirectory, originalFile.identity[0]);
  }

  public async process(targetParent: Record<string, any>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === "x-ms-examples") {
        continue;
      }

      // If the key is $ref and the value is a string then it should be a json reference. Otherwise it might be a property called $ref if it is another type.
      if (key === "$ref" && typeof value === "string") {
        const { file, path } = parseJsonRef(value);
        const newRefFileName = resolveUri(this.originalFileLocation, file ?? "");

        const newReference = path ? `${newRefFileName}#${path}` : newRefFileName;
        this.clone(targetParent, key, pointer, newReference);
      } else if (Array.isArray(value)) {
        await this.process(this.newArray(targetParent, key, pointer), children);
      } else if (value && typeof value === "object") {
        await this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        this.clone(targetParent, key, pointer, value);
      }
    }
  }
}
