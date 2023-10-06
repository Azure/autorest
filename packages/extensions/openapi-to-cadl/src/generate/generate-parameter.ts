import { CadlParameter } from "../interfaces";
import { generateDecorators } from "../utils/decorators";
import { generateDocs } from "../utils/docs";

export function generateParameter(parameter: CadlParameter): string {
  const definitions: string[] = [];
  if (parameter.location === "body") {
    definitions.push(`...${parameter.type}`);
  } else {
    const doc = generateDocs(parameter);
    definitions.push(doc);

    const decorators = generateDecorators(parameter.decorators);
    decorators && definitions.push(decorators);
    definitions.push(`"${parameter.name}"${parameter.isOptional ? "?" : ""}: ${parameter.type}`);
  }

  return definitions.join("\n");
}
