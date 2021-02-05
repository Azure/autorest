import { AutoRestRawConfiguration } from "./auto-rest-raw-configuration";
// TODO-TIM don't extend
export interface AutorestConfiguration extends AutoRestRawConfiguration {
  inputFileUris: string[];
  name?: string;
  to?: string;
}
