import { CadlProgram } from "../interfaces";
import { getOptions } from "../options";

export function getNamespace(program: CadlProgram) {
  let { namespace } = getOptions();

  namespace = namespace ?? program.serviceInformation.name.replace(/ /g, "").replace(/-/g, "");

  return `namespace ${namespace};`;
}
