import {
  CodeModel,
  ImplementationLocation,
  ParameterLocation,
} from "@autorest/codemodel";
import { EndpointParameter, ServiceInformation } from "../interfaces";
import { getFirstEndpoint } from "../utils/get-endpoint";
import { isConstantSchema } from "../utils/schemas";

export function transformServiceInformation(
  model: CodeModel
): ServiceInformation {
  return {
    name: model.info.title,
    doc:
      model.info.description ??
      "// FIXME: (miissing-service-description) Add service description",
    endpoint: getFirstEndpoint(model),
    endpointParameters: transformEndpointParameters(model),
    version: getApiVersion(model),
  };
}

export function transformEndpointParameters(
  model: CodeModel
): EndpointParameter[] {
  const globalParameters = (model.globalParameters ?? []).filter(
    (p) => p.implementation === "Client" && p.protocol?.http?.in === "uri"
  );

  return globalParameters.map((p) => ({
    doc: p.language.default.description ?? "",
    name: p.language.default.serializedName,
  }));
}

function getApiVersion(model: CodeModel): string | undefined {
  if (!model.globalParameters || !model.globalParameters.length) {
    return undefined;
  }

  const apiVersionParam = model.globalParameters
    .filter(
      (gp) =>
        gp.implementation === ImplementationLocation.Client &&
        gp.protocol.http?.in === ParameterLocation.Query
    )
    .find((param) => param.language.default.serializedName === "api-version");

  if (apiVersionParam && isConstantSchema(apiVersionParam.schema)) {
    return apiVersionParam.schema.value.value.toString();
  }

  return undefined;
}
