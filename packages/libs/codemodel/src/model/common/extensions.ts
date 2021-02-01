import { Dictionary } from "@azure-tools/linq";

/** A dictionary of open-ended 'x-*' extensions propogated from the original source document.
 *
 * @note - any unrecognized non-schema extensions found in the source model will be copied here verbatim
 *
 */
export interface Extensions {
  /** additional metadata extensions dictionary
   *
   * @notes - undefined means that there are no extensions present on the node.
   */
  extensions?: Dictionary<any>;
}
