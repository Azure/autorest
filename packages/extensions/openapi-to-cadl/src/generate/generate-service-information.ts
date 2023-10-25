import { CadlProgram, EndpointParameter } from "../interfaces";
import { getOptions } from "../options";
import { generateDocs } from "../utils/docs";
import { getNamespace } from "../utils/namespace";

export function generateServiceInformation(program: CadlProgram) {
  const { serviceInformation } = program;
  const definitions: string[] = [];
  const { isArm } = getOptions();
  if (isArm) {
    definitions.push(`@armProviderNamespace`);
  }

  definitions.push(`@service({
    title: "${serviceInformation.name}"
  })`);

  if (serviceInformation.version) {
    definitions.push(`@versioned(Versions)`);
  }

  if (!isArm && serviceInformation.endpoint) {
    definitions.push(`@server("${serviceInformation.endpoint}", ${JSON.stringify(serviceInformation.doc) ?? ""}`);
    const parametrizedHost = getEndpointParameters(serviceInformation.endpoint);
    const hasParameters =
      (serviceInformation.endpointParameters && serviceInformation.endpointParameters.length) ||
      parametrizedHost.length;

    const allParams: EndpointParameter[] = [
      ...(serviceInformation.endpointParameters ?? []).filter((p) => !parametrizedHost.some((e) => e.name === p.name)),
      ...parametrizedHost,
    ];
    if (hasParameters) {
      definitions.push(", {");
      for (const param of allParams ?? []) {
        const doc = generateDocs(param);
        doc && definitions.push(doc);
        definitions.push(`${param.name}: string `);
      }
    }
    hasParameters && definitions.push("}");
    definitions.push(")");
  }
  const serviceDoc = generateDocs(serviceInformation);
  serviceDoc && definitions.push(serviceDoc);

  definitions.push(getNamespace(program));

  if (serviceInformation.version) {
    definitions.push("");
    definitions.push(`@doc("The available API versions.")`);
    definitions.push(`enum Versions {`);
    if (isArm) {
      definitions.push(`@useDependency(Azure.ResourceManager.Versions.v1_0_Preview_1)`);
      definitions.push(`@useDependency(Azure.Core.Versions.v1_0_Preview_1)`);
    }
    definitions.push(`v${serviceInformation.version.replaceAll("-", "_")}: "${serviceInformation.version}",`);
    definitions.push("}");
  }

  return definitions.join("\n");
}

function getEndpointParameters(endpoint: string) {
  const regex = /{([^{}]+)}/g;
  const params: EndpointParameter[] = [];
  let match;
  while ((match = regex.exec(endpoint)) !== null) {
    params.push({ name: match[1] });
  }

  return params;
}
