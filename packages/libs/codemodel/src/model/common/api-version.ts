/** an expression of an API version or api version range.
 *
 * @description - since API version formats range from
 * Azure ARM API date style (2018-01-01) to semver (1.2.3)
 * and virtually any other text, this value tends to be an
 * opaque string with the possibility of a modifier to indicate
 * that it is a range.
 *
 * options:
 *   - prepend a dash or append a plus to indicate a range
 *     (ie, '2018-01-01+' or '-2019-01-01', or '1.0+' )
 *
 *   - semver-range style (ie, '^1.0.0' or '~1.0.0' )
 */
export interface ApiVersion {
  /** the actual api version string used in the API */
  version: string;
  range?: "-" | "+";
}

export class ApiVersion implements ApiVersion {}
/** a collection of api versions */
export type ApiVersions = Array<ApiVersion>;
