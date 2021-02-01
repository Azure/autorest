import { Dictionary } from "@azure-tools/linq";
import { Extensions } from "./extensions";
import { Languages } from "./languages";
import { Protocols } from "./protocols";
import { Initializer, DeepPartial } from "@azure-tools/codegen";
import { SetType } from "../../tag";

/** common pattern for Metadata on aspects */
export interface Metadata extends Extensions {
  /** per-language information for this aspect */
  language: Languages;

  /** per-protocol information for this aspect  */
  protocol: Protocols;
}

export class Metadata extends Initializer implements Metadata {
  constructor(objectInitializer?: DeepPartial<Metadata>) {
    super();
    this.language = SetType(Languages, {
      default: {
        name: "",
        description: "",
      },
    });

    this.protocol = SetType(Protocols, {});
    this.apply(objectInitializer);
  }
}

/** the bare-minimum fields for per-language metadata on a given aspect */
export interface Language extends Dictionary<any> {
  /** name used in actual implementation */
  name: string;

  /** description text - describes this node. */
  description: string;
}
export class Language implements Language {}

export interface CSharpLanguage {}

export class CSharpLanguage implements CSharpLanguage {}

/** the bare-minimum fields for per-protocol metadata on a given aspect */
export interface Protocol extends Dictionary<any> {}

export class Protocol extends Initializer implements Protocol {
  constructor(objectInitializer?: DeepPartial<Protocol>) {
    super();
    this.apply(objectInitializer);
  }
}
