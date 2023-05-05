import { CodeModel, ImplementationLocation, ParameterLocation } from "@autorest/codemodel";
import { EndpointParameter, ServiceInformation } from "../interfaces";
import { getFirstEndpoint } from "../utils/get-endpoint";
import { isConstantSchema } from "../utils/schemas";

export function transformServiceInformation(model: CodeModel): ServiceInformation {
  return {
    name: model.info.title,
    doc: model.info.description ?? "// FIXME: (miissing-service-description) Add service description",
    endpoint: getFirstEndpoint(model),
    endpointParameters: transformEndpointParameters(model),
    version: getApiVersion(model),
  };
}

export function transformEndpointParameters(model: CodeModel): EndpointParameter[] {
  const globalParameters = (model.globalParameters ?? []).filter(
    (p) => p.implementation === "Client" && p.protocol?.http?.in === "uri",
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
      (gp) => gp.implementation === ImplementationLocation.Client && gp.protocol.http?.in === ParameterLocation.Query,
    )
    .find((param) => param.language.default.serializedName === "api-version");

  if (apiVersionParam && isConstantSchema(apiVersionParam.schema)) {
    return apiVersionParam.schema.value.value.toString();
  }

  return undefined;
}

function getEndpointParameter(codeModel: CodeModel) {
  if (!codeModel.globalParameters || !codeModel.globalParameters.length) {
    return [];
  }

  const urlParameters = codeModel.globalParameters.filter(
    (gp) => gp.implementation === ImplementationLocation.Client && gp.protocol.http?.in === ParameterLocation.Uri,
  );

  // Currently only support one parametrized host
  if (!urlParameters.length) {
    return [];
  }

  return urlParameters.map((urlParameter) => {
    let value: string | undefined;
    if (isConstantSchema(urlParameter.schema)) {
      value = urlParameter.schema.value.value;
    }
    return {
      name: urlParameter.language.default.serializedName,
      type: "string",
      description: urlParameter.language.default.description,
      value,
    };
  });
}

export function transformBaseUrl(codeModel: CodeModel) {
  let endpoint: string | undefined = "";
  let isCustom = false;

  const $host = (codeModel.globalParameters || []).find((p) => {
    const { name } = p.language.default;
    return name === "$host" && Boolean(p.clientDefaultValue);
  });

  let urlParameters: any[] = [];
  if (!$host) {
    // There are some swaggers that contain no operations for those we'll keep an empty endpoint
    if (codeModel.operationGroups && codeModel.operationGroups.length) {
      // No support yet for multi-baseUrl yet Issue #553
      const { requests } = codeModel.operationGroups[0].operations[0];
      urlParameters = getEndpointParameter(codeModel);
      isCustom = true;
      endpoint = requests?.[0].protocol.http?.uri;
    }
  } else {
    endpoint = $host.clientDefaultValue;
  }

  return {
    urlParameters,
    endpoint: endpoint,
    isCustom,
  };
}
