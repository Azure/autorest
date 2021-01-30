import { Language, CSharpLanguage } from "./metadata";

/** custom extensible metadata for individual language generators */
export interface Languages {
  default: Language;
  csharp?: Language;
  python?: Language;
  ruby?: Language;
  go?: Language;
  typescript?: Language;
  javascript?: Language;
  powershell?: Language;
  java?: Language;
  c?: Language;
  cpp?: Language;
  swift?: Language;
  objectivec?: Language;
  sputnik?: Language;
}

export class Languages implements Languages {}
