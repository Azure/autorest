import { CodeModel } from "@autorest/codemodel";
import { tagSchemaAsResource } from "../utils/resource-discovery";

export function pretransformArmResources(codeModel: CodeModel): void {
  for (const schema of codeModel.schemas?.objects ?? []) {
    tagSchemaAsResource(schema);
  }
}
