import { ApiVersions } from './api-version';

/** represents  deprecation information for a given aspect  */
export interface Deprecation {

  /** the reason why this aspect  */
  message: string;

  /** the api versions that this deprecation is applicable to. */
  apiVersions: ApiVersions;
}
