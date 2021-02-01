import { Extensions } from "./extensions";
import { uri } from "./uri";
import { Initializer, DeepPartial } from "@azure-tools/codegen";

/** a reference to external documentation  */
export interface ExternalDocumentation extends Extensions {
  description?: string;
  url: uri; // uriref
}

export class ExternalDocumentation extends Initializer implements ExternalDocumentation {
  constructor(public url: uri, initializer?: DeepPartial<ExternalDocumentation>) {
    super();
    this.apply(initializer);
  }
}
