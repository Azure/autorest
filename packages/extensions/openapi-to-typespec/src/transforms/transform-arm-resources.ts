import {
  ArraySchema,
  ObjectSchema,
  Operation,
  Parameter,
  Property,
  Response,
  SchemaResponse,
  SchemaType,
} from "@autorest/codemodel";
import _ from "lodash";
import pluralize, { singular } from "pluralize";
import { getArmCommonTypeVersion, getSession } from "../autorest-session";
import { getDataTypes } from "../data-types";
import {
  ArmResourceKind,
  TypespecDecorator,
  TypespecObjectProperty,
  TypespecParameter,
  TspArmResource,
  TspArmResourceOperation,
  isFirstLevelResource,
  TypespecTemplateModel,
  TspArmOperationType,
  TspArmResourceActionOperation,
  TspArmResourceOperationBase,
  TypespecVoidType,
  TspArmResourceLifeCycleOperation,
  TspArmResourceListOperation,
  isArmResourceActionOperation,
  TypespecDataType,
} from "../interfaces";
import { getOptions, updateOptions } from "../options";
import { createClientNameDecorator, createCSharpNameDecorator } from "../pretransforms/rename-pretransform";
import { getOperationClientDecorators } from "../utils/decorators";
import { generateDocsContent } from "../utils/docs";
import { getLogger } from "../utils/logger";
import {
  ArmResource,
  ArmResourceSchema,
  _ArmResourceOperation,
  getResourceOperations,
  isResourceSchema,
} from "../utils/resource-discovery";
import { isArraySchema, isResponseSchema } from "../utils/schemas";
import { getSuppresssionWithCode } from "../utils/suppressions";
import {
  getFullyQualifiedName,
  getTemplateResponses,
  isResourceListResult,
  NamesOfResponseTemplate,
} from "../utils/type-mapping";
import { getTypespecType, isTypespecType, transformObjectProperty } from "./transform-object";
import { transformParameter } from "./transform-operations";

const logger = () => getLogger("parse-metadata");

const armResourceCache: Map<ArmResourceSchema, TspArmResource> = new Map<ArmResourceSchema, TspArmResource>();
export function transformTspArmResource(schema: ArmResourceSchema): TspArmResource {
  if (armResourceCache.has(schema)) return armResourceCache.get(schema)!;

  const { isFullCompatible } = getOptions();
  const fixMe: string[] = [];

  if (!getSession().configuration["namespace"]) {
    const segments = schema.resourceMetadata.GetOperations[0].Path.split("/");
    for (let i = segments.length - 1; i >= 0; i--) {
      if (segments[i] === "providers") {
        getSession().configuration["namespace"] = segments[i + 1];
        updateOptions();
        break;
      }
    }
  }

  // TODO: deal with a resource with multiple parents
  if (schema.resourceMetadata.Parents.length > 1) {
    fixMe.push(
      `// FIXME: ${schema.resourceMetadata.SwaggerModelName} has more than one parent, currently converter will only use the first one`,
    );
  }

  const propertiesModel = schema.properties?.find((p) => p.serializedName === "properties");
  const propertiesModelSchema = propertiesModel?.schema;
  let propertiesModelName = propertiesModelSchema?.language.default.name;
  let propertiesPropertyRequired = false;
  let propertiesPropertyDescription = "";

  if (propertiesModelSchema?.type === SchemaType.Dictionary) {
    propertiesModelName = "Record<unknown>";
  } else if (propertiesModelSchema?.type === SchemaType.Object) {
    propertiesPropertyRequired = propertiesModel?.required ?? false;
    propertiesPropertyDescription = propertiesModel?.language.default.description ?? "";
  }

  // TODO: deal with resources that has no properties property
  if (!propertiesModelName) {
    fixMe.push(`// FIXME: ${schema.resourceMetadata.SwaggerModelName} has no properties property`);
    propertiesModelName = "{}";
  }

  const armResourceOperations = getTspOperations(schema);

  let baseModelName = undefined;
  if (!getArmCommonTypeVersion()) {
    const immediateParents = schema.parents?.immediate ?? [];

    baseModelName = immediateParents
      .filter((p) => p.language.default.name !== schema.language.default.name)
      .map((p) => p.language.default.name)[0];
  }

  const decorators = buildResourceDecorators(schema);
  if (!getArmCommonTypeVersion() && schema.resourceMetadata.IsExtensionResource) {
    decorators.push({ name: "extensionResource" });
  }

  const clientDecorators = buildResourceClientDecorators(schema);
  const keyProperty = buildKeyProperty(schema);
  const properties = [...getOtherProperties(schema, !getArmCommonTypeVersion())];
  let keyExpression, augmentDecorators;
  if (keyProperty.name === "name") {
    keyExpression = buildKeyExpression(schema, keyProperty);
    augmentDecorators = buildKeyAugmentDecorators(schema, keyProperty);
  } else {
    properties.unshift(keyProperty);
  }

  if (propertiesModel) {
    if (augmentDecorators === undefined) augmentDecorators = buildPropertiesAugmentDecorators(schema, propertiesModel);
    else augmentDecorators.push(...buildPropertiesAugmentDecorators(schema, propertiesModel));
  }

  const propertiesPropertyClientDecorator = [];
  if (isFullCompatible && propertiesModel?.extensions?.["x-ms-client-flatten"]) {
    propertiesPropertyClientDecorator.push({
      name: "flattenProperty",
      module: "@azure-tools/typespec-client-generator-core",
      namespace: "Azure.ClientGenerator.Core",
      suppressionCode: "deprecated",
      suppressionMessage: "@flattenProperty decorator is not recommended to use.",
    });
  }

  const tspResource: TspArmResource = {
    fixMe,
    resourceKind: getResourceKind(schema),
    kind: "object",
    properties,
    keyExpression,
    name: schema.resourceMetadata.SwaggerModelName,
    parents: [],
    resourceParent: getParentResource(schema),
    propertiesModelName,
    propertiesPropertyRequired,
    propertiesPropertyDescription,
    propertiesPropertyClientDecorator,
    doc: schema.language.default.description,
    decorators,
    clientDecorators,
    augmentDecorators,
    resourceOperations: armResourceOperations,
    normalOperations: [],
    optionalStandardProperties: getArmCommonTypeVersion() ? getResourceOptionalStandardProperties(schema) : [],
    baseModelName,
    locationParent: getLocationParent(schema),
  };
  armResourceCache.set(schema, tspResource);
  return tspResource;
}

function getTspOperations(armSchema: ArmResourceSchema): TspArmResourceOperation[] {
  const resourceMetadata = armSchema.resourceMetadata;
  const operations = getResourceOperations(resourceMetadata);
  const tspOperations: TspArmResourceOperation[] = [];

  // TODO: handle operations under resource group / management group / tenant

  // read operation
  tspOperations.push(...convertResourceReadOperation(resourceMetadata, operations));

  // exist operation
  tspOperations.push(...convertResourceExistsOperation(resourceMetadata, operations));

  // create operation
  tspOperations.push(...convertResourceCreateOrReplaceOperation(resourceMetadata, operations));

  // patch update operation could either be patch for resource/tag or custom patch
  tspOperations.push(...convertResourceUpdateOperation(resourceMetadata, operations));

  // delete operation
  tspOperations.push(...convertResourceDeleteOperation(resourceMetadata, operations));

  // list operation
  tspOperations.push(...convertResourceListOperations(resourceMetadata, operations));

  // action operation
  tspOperations.push(...convertResourceActionOperations(resourceMetadata, operations));

  return tspOperations;
}

function convertResourceReadOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  // every resource should have a get operation
  const operation = resourceMetadata.GetOperations[0];
  const swaggerOperation = operations[operation.OperationID];
  return [
    buildNewArmOperation(
      resourceMetadata,
      operation,
      swaggerOperation,
      "ArmResourceRead",
    ) as TspArmResourceLifeCycleOperation,
  ];
}

function convertResourceExistsOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const operation = resourceMetadata.ExistOperation;
  if (operation) {
    const swaggerOperation = operations[operation.OperationID];
    const armOperation = buildNewArmOperation(
      resourceMetadata,
      operation,
      swaggerOperation,
      "ArmResourceCheckExistence",
    );
    if (!swaggerOperation.operationId) armOperation.name = "exists";
    return [armOperation as TspArmResourceLifeCycleOperation];
  }
  return [];
}

function convertResourceCreateOrReplaceOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const { isFullCompatible } = getOptions();
  if (resourceMetadata.CreateOperations.length) {
    const operation = resourceMetadata.CreateOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
    const armOperation = buildNewArmOperation(
      resourceMetadata,
      operation,
      swaggerOperation,
      isLongRunning ? "ArmResourceCreateOrReplaceAsync" : "ArmResourceCreateOrReplaceSync",
    );

    const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
    if (!bodyParam) {
      armOperation.fixMe = [
        "// FIXME: (ArmResourceCreateOrReplace): ArmResourceCreateOrReplaceAsync/ArmResourceCreateOrReplaceSync should have a body parameter.",
      ];
    }

    const finalStateVia =
      swaggerOperation.extensions?.["x-ms-long-running-operation-options"]?.["final-state-via"] ?? "location";
    armOperation.lroHeaders = isLongRunning && finalStateVia === "location" ? "Location" : undefined;

    buildBodyDecorator(bodyParam, armOperation, resourceMetadata, "resource", "Resource create parameters.");

    const asyncNames: NamesOfResponseTemplate = {
      _200Name: "ArmResourceUpdatedResponse",
      _200NameNoBody: "OkResponse",
      _201Name: "ArmResourceCreatedResponse",
      _201NameNoBody: "CreatedResponse",
      _202Name: "ArmAcceptedLroResponse",
      _202NameNoBody: "ArmAcceptedLroResponse",
      _204Name: "ArmNoContentResponse",
    };
    const syncNames: NamesOfResponseTemplate = {
      _200Name: "ArmResourceUpdatedResponse",
      _200NameNoBody: "OkResponse",
      _201Name: "ArmResourceCreatedSyncResponse",
      _201NameNoBody: "CreatedResponse",
      _202Name: "AcceptedResponse",
      _202NameNoBody: "AcceptedResponse",
      _204Name: "ArmNoContentResponse",
    };
    let responses: TypespecTemplateModel[] = isLongRunning
      ? getTemplateResponses(swaggerOperation, asyncNames)
      : getTemplateResponses(swaggerOperation, syncNames);
    if (
      isLongRunning &&
      responses.length === 2 &&
      responses.find(
        (r) =>
          r.name === asyncNames._200Name &&
          r.arguments?.length === 1 &&
          r.arguments[0].name === resourceMetadata.SwaggerModelName,
      ) &&
      responses.find(
        (r) =>
          r.name === asyncNames._201Name &&
          r.arguments?.length === 1 &&
          r.arguments[0].name === resourceMetadata.SwaggerModelName,
      )
    )
      responses = [];
    if (
      !isLongRunning &&
      responses.length === 2 &&
      responses.find(
        (r) =>
          r.name === syncNames._200Name &&
          r.arguments?.length === 1 &&
          r.arguments[0].name === resourceMetadata.SwaggerModelName,
      ) &&
      responses.find(
        (r) =>
          r.name === syncNames._200Name &&
          r.arguments?.length === 1 &&
          r.arguments[0].name === resourceMetadata.SwaggerModelName,
      )
    )
      responses = [];
    if (responses.length > 0) armOperation.response = responses;
    if (armOperation.lroHeaders && responses) {
      let _201Response = responses.find((r) => r.name === asyncNames._201Name);
      if (_201Response) {
        _201Response.arguments!.push({
          kind: "&",
          name: "ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader",
        }); //TO-DO: do it in a better way
        armOperation.lroHeaders = undefined;
      }

      _201Response = responses.find((r) => r.name === syncNames._201NameNoBody);
      if (_201Response) {
        _201Response.additionalTemplateModel = "ArmLroLocationHeader & Azure.Core.Foundations.RetryAfterHeader";
      }
    }

    if (isFullCompatible) {
      if (armOperation.response) {
        armOperation.suppressions = armOperation.suppressions ?? [];
        armOperation.suppressions.push(
          getSuppresssionWithCode("@azure-tools/typespec-azure-resource-manager/arm-put-operation-response-codes"),
        );

        if (
          (armOperation.response as TypespecTemplateModel[]).find(
            (r) => r.name === asyncNames._202Name && (!r.arguments || r.arguments.length === 0),
          )
        ) {
          armOperation.suppressions.push(
            getSuppresssionWithCode("@azure-tools/typespec-azure-resource-manager/no-response-body"),
          );
        }
      }
    }

    return [armOperation as TspArmResourceLifeCycleOperation];
  }
  return [];
}

function convertResourceUpdateOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  if (resourceMetadata.UpdateOperations.length) {
    const operation = resourceMetadata.UpdateOperations[0];
    if (
      !resourceMetadata.CreateOperations.length ||
      resourceMetadata.CreateOperations[0].OperationID !== operation.OperationID
    ) {
      const swaggerOperation = operations[operation.OperationID];
      const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
      const armOperation = buildNewArmOperation(
        resourceMetadata,
        operation,
        swaggerOperation,
        isLongRunning ? "ArmCustomPatchAsync" : "ArmCustomPatchSync",
      );

      const finalStateVia =
        swaggerOperation.extensions?.["x-ms-long-running-operation-options"]?.["final-state-via"] ?? "location";
      armOperation.lroHeaders =
        isLongRunning && finalStateVia === "azure-async-operation" ? "Azure-AsyncOperation" : undefined;

      const bodyParam = swaggerOperation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
      if (!bodyParam) {
        armOperation.fixMe = [
          "// FIXME: (ArmResourcePatch): ArmResourcePatchSync/ArmResourcePatchAsync should have a body parameter with either properties property or tag property",
        ];
        armOperation.patchModel = "{}";
      } else {
        armOperation.patchModel = bodyParam.schema.language.default.name;
      }

      buildBodyDecorator(
        bodyParam,
        armOperation,
        resourceMetadata,
        "properties",
        "The resource properties to be updated.",
      );

      const asyncNames: NamesOfResponseTemplate = {
        _200Name: "ArmResponse",
        _200NameNoBody: "OkResponse",
        _201Name: "ArmResourceCreatedResponse",
        _201NameNoBody: "CreatedResponse",
        _202Name: "ArmAcceptedLroResponse",
        _202NameNoBody: "ArmAcceptedLroResponse",
        _204Name: "ArmNoContentResponse",
      };
      const syncNames: NamesOfResponseTemplate = {
        _200Name: "ArmResponse",
        _200NameNoBody: "OkResponse",
        _201Name: "ArmResourceCreatedSyncResponse",
        _201NameNoBody: "CreatedResponse",
        _202Name: "AcceptedResponse",
        _202NameNoBody: "AcceptedResponse",
        _204Name: "ArmNoContentResponse",
      };
      let responses = isLongRunning
        ? getTemplateResponses(swaggerOperation, asyncNames)
        : getTemplateResponses(swaggerOperation, syncNames);
      if (
        isLongRunning &&
        responses.length === 2 &&
        responses.find(
          (r) =>
            r.name === asyncNames._200Name &&
            r.arguments?.length === 1 &&
            r.arguments[0].name === resourceMetadata.SwaggerModelName,
        ) &&
        responses.find((r) => r.name === asyncNames._202NameNoBody && !r.arguments)
      )
        responses = [];
      if (
        !isLongRunning &&
        responses.length === 1 &&
        responses.find(
          (r) =>
            r.name === syncNames._200Name &&
            r.arguments?.length === 1 &&
            r.arguments[0].name === resourceMetadata.SwaggerModelName,
        )
      )
        responses = [];
      if (responses.length > 0) armOperation.response = responses;
      if (armOperation.lroHeaders && responses) {
        const _202response = responses.find(
          (r) => r.name === asyncNames._202NameNoBody || r.name === asyncNames._202Name,
        );
        if (_202response) {
          _202response.arguments = [
            { kind: "&", name: "ArmAsyncOperationHeader & Azure.Core.Foundations.RetryAfterHeader" },
          ]; //TO-DO: do it in a better way
          armOperation.lroHeaders = undefined;
        }
      }

      armOperation.decorators = [{ name: "parameterVisibility", arguments: [] }];
      return [armOperation as TspArmResourceLifeCycleOperation];
    }
  }
  return [];
}

function convertResourceDeleteOperation(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const { isFullCompatible } = getOptions();

  if (resourceMetadata.DeleteOperations.length) {
    const operation = resourceMetadata.DeleteOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
    const armOperation = buildNewArmOperation(
      resourceMetadata,
      operation,
      swaggerOperation,
      isLongRunning ? "ArmResourceDeleteWithoutOkAsync" : "ArmResourceDeleteSync",
    );

    const finalStateVia =
      swaggerOperation.extensions?.["x-ms-long-running-operation-options"]?.["final-state-via"] ?? "location";
    armOperation.lroHeaders =
      isLongRunning && finalStateVia === "azure-async-operation" ? "Azure-AsyncOperation" : undefined;

    if (armOperation.lroHeaders && isFullCompatible) {
      armOperation.suppressions = armOperation.suppressions ?? [];
      armOperation.suppressions.push(
        getSuppresssionWithCode("@azure-tools/typespec-azure-resource-manager/lro-location-header"),
      );
    }

    const asyncNames: NamesOfResponseTemplate = {
      _200Name: "ArmResponse",
      _200NameNoBody: "ArmDeletedResponse",
      _201Name: "ArmResourceCreatedResponse",
      _201NameNoBody: "CreatedResponse",
      _202Name: "ArmDeleteAcceptedLroResponse",
      _202NameNoBody: "ArmDeleteAcceptedLroResponse",
      _204Name: "ArmDeletedNoContentResponse",
    };
    const syncNames: NamesOfResponseTemplate = {
      _200Name: "ArmResponse",
      _200NameNoBody: "ArmDeletedResponse",
      _201Name: "ArmResourceCreatedSyncResponse",
      _201NameNoBody: "CreatedResponse",
      _202Name: "AcceptedResponse",
      _202NameNoBody: "AcceptedResponse",
      _204Name: "ArmDeletedNoContentResponse",
    };
    let responses = isLongRunning
      ? getTemplateResponses(swaggerOperation, asyncNames)
      : getTemplateResponses(swaggerOperation, syncNames);
    if (
      isLongRunning &&
      responses.length === 2 &&
      responses.find((r) => r.name === asyncNames._202NameNoBody && !r.arguments) &&
      responses.find((r) => r.name === asyncNames._204Name && !r.arguments)
    )
      responses = [];
    if (
      !isLongRunning &&
      responses.length === 2 &&
      responses.find((r) => r.name === syncNames._200NameNoBody && !r.arguments) &&
      responses.find((r) => r.name === asyncNames._204Name && !r.arguments)
    )
      responses = [];
    if (armOperation.lroHeaders && responses) {
      const _202response = responses.find(
        (r) => r.name === asyncNames._202NameNoBody || r.name === asyncNames._202Name,
      );
      if (_202response) {
        _202response.arguments = [
          { kind: "&", name: "ArmAsyncOperationHeader & Azure.Core.Foundations.RetryAfterHeader" },
        ]; //TO-DO: do it in a better way
        armOperation.lroHeaders = undefined;
      }
    }
    if (responses.length > 0) armOperation.response = responses;

    if (armOperation.response && isFullCompatible) {
      armOperation.suppressions = armOperation.suppressions ?? [];
      armOperation.suppressions.push(
        getSuppresssionWithCode("@azure-tools/typespec-azure-resource-manager/arm-delete-operation-response-codes"),
      );
    }

    return [armOperation as TspArmResourceLifeCycleOperation];
  }
  return [];
}

function convertResourceListOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceOperation[] {
  const converted: TspArmResourceOperation[] = [];

  // list by parent operation
  if (resourceMetadata.ListOperations.length) {
    // TODO: TParentName, TParentFriendlyName
    const operation = resourceMetadata.ListOperations[0];
    const swaggerOperation = operations[operation.OperationID];
    const armOperation = buildNewArmOperation(resourceMetadata, operation, swaggerOperation, "ArmResourceListByParent");

    const syncNames: NamesOfResponseTemplate = {
      _200Name: "ArmResponse",
      _200NameNoBody: "OkResponse",
      _201Name: "ArmResourceCreatedSyncResponse",
      _201NameNoBody: "CreatedResponse",
      _202Name: "AcceptedResponse",
      _202NameNoBody: "AcceptedResponse",
      _204Name: "NoContentResponse",
    };
    let responses = getTemplateResponses(swaggerOperation, syncNames);
    if (
      responses.length === 1 &&
      responses[0].name === syncNames._200Name &&
      responses[0].arguments?.[0].name === "ResourceListResult"
    )
      responses = [];
    if (responses.length > 0) armOperation.response = responses;

    converted.push(armOperation as TspArmResourceListOperation);
  }

  // list operation under subscription
  if (resourceMetadata.OperationsFromSubscriptionExtension.length) {
    for (const operation of resourceMetadata.OperationsFromSubscriptionExtension) {
      if (operation.PagingMetadata) {
        const swaggerOperation = operations[operation.OperationID];
        const armOperation = buildNewArmOperation(
          resourceMetadata,
          operation,
          swaggerOperation,
          "ArmResourceListAtScope",
        );

        const syncNames: NamesOfResponseTemplate = {
          _200Name: "ArmResponse",
          _200NameNoBody: "OkResponse",
          _201Name: "ArmResourceCreatedSyncResponse",
          _201NameNoBody: "CreatedResponse",
          _202Name: "AcceptedResponse",
          _202NameNoBody: "AcceptedResponse",
          _204Name: "NoContentResponse",
        };
        let responses = getTemplateResponses(swaggerOperation, syncNames);
        if (
          responses.length === 1 &&
          responses[0].name === syncNames._200Name &&
          responses[0].arguments?.[0].name === "ResourceListResult"
        )
          responses = [];
        if (responses.length > 0) armOperation.response = responses;

        // either list in location or list in subscription
        if (operation.Path.includes("/locations/")) {
          armOperation.baseParameters = [getFullyQualifiedName("LocationBaseParameters")];
        } else {
          armOperation.kind = "ArmListBySubscription";
        }
        converted.push(armOperation as TspArmResourceListOperation);
      }
    }
  }

  return converted;
}

function convertResourceActionOperations(
  resourceMetadata: ArmResource,
  operations: Record<string, Operation>,
): TspArmResourceActionOperation[] {
  const codeModel = getSession().model;
  const dataTypes = getDataTypes(codeModel);

  const converted: TspArmResourceActionOperation[] = [];

  if (resourceMetadata.OtherOperations.length) {
    for (const operation of resourceMetadata.OtherOperations) {
      const swaggerOperation = operations[operation.OperationID];
      const isLongRunning = swaggerOperation.extensions?.["x-ms-long-running-operation"] ?? false;
      const armOperation = buildNewArmOperation(
        resourceMetadata,
        operation,
        swaggerOperation,
        isLongRunning ? "ArmResourceActionAsync" : "ArmResourceActionSync",
      );

      const finalStateVia =
        swaggerOperation.extensions?.["x-ms-long-running-operation-options"]?.["final-state-via"] ?? "location";
      armOperation.lroHeaders =
        isLongRunning && finalStateVia === "azure-async-operation" ? "Azure-AsyncOperation" : undefined;

      buildRequestForAction(
        armOperation,
        swaggerOperation,
        resourceMetadata,
        true,
        "body",
        "The content of the action request",
      );

      armOperation.decorators = armOperation.decorators ?? [];
      if (operation.Method !== "POST") {
        armOperation.decorators.push({ name: operation.Method.toLocaleLowerCase() });
      }
      const segments = operation.Path.split("/");
      if (segments[segments.length - 1] !== armOperation.name) {
        armOperation.decorators.push({ name: "action", arguments: [segments[segments.length - 1]] });
      }

      const asyncNames: NamesOfResponseTemplate = {
        _200Name: "ArmResponse",
        _200NameNoBody: "OkResponse",
        _201Name: "ArmResourceCreatedResponse",
        _201NameNoBody: "CreatedResponse",
        _202Name: "ArmAcceptedLroResponse",
        _202NameNoBody: "ArmAcceptedLroResponse",
        _204Name: "NoContentResponse",
      };
      const syncNames: NamesOfResponseTemplate = {
        _200Name: "ArmResponse",
        _200NameNoBody: "OkResponse",
        _201Name: "ArmResourceCreatedSyncResponse",
        _201NameNoBody: "CreatedResponse",
        _202Name: "AcceptedResponse",
        _202NameNoBody: "AcceptedResponse",
        _204Name: "NoContentResponse",
      };
      let responses: TypespecTemplateModel[] | TypespecVoidType = isLongRunning
        ? getTemplateResponses(swaggerOperation, asyncNames)
        : getTemplateResponses(swaggerOperation, syncNames);

      if (isLongRunning) {
        const _202NoBodyResponseIndex = responses.findIndex(
          (r) => r.name === asyncNames._202NameNoBody && !r.arguments,
        );
        if (_202NoBodyResponseIndex >= 0) {
          responses.splice(_202NoBodyResponseIndex, 1);
        } else {
          armOperation.kind = "ArmResourceActionAsyncBase";
          armOperation.baseParameters = armOperation.baseParameters ?? [
            `${getFullyQualifiedName("DefaultBaseParameters")}<${armOperation.resource}>`,
          ];
          const _202Response = responses.find((r) => r.name === asyncNames._202Name);
          if (_202Response && armOperation.lroHeaders === "Azure-AsyncOperation") {
            _202Response.arguments!.push({
              kind: "&",
              name: "ArmAsyncOperationHeader & Azure.Core.Foundations.RetryAfterHeader",
            });
          }
        }
      }
      if (responses.length === 0) responses = { kind: "void", name: "_" };
      armOperation.response = responses;

      converted.push(armOperation as TspArmResourceActionOperation);
    }
  }

  return converted;
}

function buildRequestForAction(
  armOperation: TspArmResourceOperationBase,
  operation: Operation,
  resourceMetadata: ArmResource,
  templateRequired: boolean,
  templateName: string,
  templateDoc: string,
): void {
  if (!isArmResourceActionOperation(armOperation)) {
    throw new Error(`Operation ${operation.operationId} is not an action operation.`);
  }

  const bodyParam = operation.requests?.[0].parameters?.find((p) => p.protocol.http?.in === "body");
  if (bodyParam === undefined) {
    armOperation.request = { kind: "void", name: "_" };
    return;
  }

  const bodyType = getTypespecType(bodyParam.schema, getSession().model);
  if (bodyParam.required !== templateRequired || isTypespecType(bodyType)) {
    armOperation.request = {
      kind: "parameter",
      type: bodyType,
      name: bodyParam.language.default.name,
      isOptional: !bodyParam.required,
      location: "body",
      serializedName: "_",
      decorators: [{ name: "bodyRoot" }],
      doc: bodyParam.language.default.description,
    };
    return;
  }

  armOperation.request = { kind: "object", name: bodyType };
  buildBodyDecorator(bodyParam, armOperation, resourceMetadata, templateName, templateDoc);
}

function buildBodyDecorator(
  bodyParam: Parameter | undefined,
  armOperation: TspArmResourceOperationBase,
  resourceMetadata: ArmResource,
  templateName: string,
  templateDoc: string,
): void {
  const tspOperationGroupName = getTSPOperationGroupName(resourceMetadata.SwaggerModelName);
  const [augmentedDecorators, clientDecorators] = getBodyDecorators(
    bodyParam,
    tspOperationGroupName,
    armOperation.name,
    templateName,
    templateDoc,
  );
  armOperation.augmentedDecorators = armOperation.augmentedDecorators
    ? armOperation.augmentedDecorators.concat(augmentedDecorators)
    : augmentedDecorators;
  armOperation.clientDecorators = armOperation.clientDecorators
    ? armOperation.clientDecorators.concat(clientDecorators)
    : clientDecorators;
}

function getOtherProperties(schema: ArmResourceSchema, noCommonTypes: boolean): TypespecObjectProperty[] {
  const knownProperties = ["properties", "name"];
  if (!noCommonTypes) {
    knownProperties.push(...["id", "type", "systemData", "location", "tags", "identity", "sku", "eTag", "plan"]);
  }
  const otherProperties: TypespecObjectProperty[] = [];
  for (const property of schema.properties ?? []) {
    if (!knownProperties.includes(property.serializedName)) {
      otherProperties.push(transformObjectProperty(property, getSession().model));
    }
  }
  return otherProperties;
}

function getResourceOptionalStandardProperties(schema: ArmResourceSchema): string[] {
  const optionalStandardProperties = [];

  const msi = schema.properties?.find((p) => p.serializedName === "identity");
  if (msi) {
    let msiType;
    if (msi.schema.language.default.name === "ManagedServiceIdentity") {
      msiType = "Azure.ResourceManager.ManagedServiceIdentityProperty";
    } else if (msi.schema.language.default.name === "SystemAssignedServiceIdentity") {
      msiType = "Azure.ResourceManager.ManagedSystemAssignedIdentityProperty";
    } else {
      // TODO: handle non-standard property
      msiType = "Azure.ResourceManager.ManagedServiceIdentityProperty";
    }
    optionalStandardProperties.push(msiType);
  }

  if (schema.properties?.find((p) => p.serializedName === "sku")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourceSkuProperty");
  }

  if (schema.properties?.find((p) => p.serializedName === "eTag")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.EntityTagProperty");
  }

  if (schema.properties?.find((p) => p.serializedName === "plan")) {
    // TODO: handle non-standard property
    optionalStandardProperties.push("Azure.ResourceManager.ResourcePlanProperty");
  }

  return optionalStandardProperties;
}

export function getTSPOperationGroupName(resourceName: string): string {
  const codeModel = getSession().model;
  const operationGroupName = pluralize(resourceName);
  if (
    operationGroupName === resourceName ||
    codeModel.schemas.objects?.find((o) => o.language.default.name === operationGroupName)
  ) {
    return `${operationGroupName}OperationGroup`;
  } else {
    return operationGroupName;
  }
}

function getBodyDecorators(
  bodyParam: Parameter | undefined,
  tspOperationGroupName: string,
  operationName: string,
  templateName: string,
  templateDoc: string,
): [string[], TypespecDecorator[]] {
  const { isFullCompatible } = getOptions();

  const augmentedDecorators = [];
  const clientDecorators = [];
  if (bodyParam) {
    if (bodyParam.language.default.name !== templateName && isFullCompatible) {
      clientDecorators.push(
        createClientNameDecorator(
          `${tspOperationGroupName}.${operationName}::parameters.${templateName}`,
          `${bodyParam.language.default.name}`,
        ),
      );
    }
    if (bodyParam.language.default.description !== templateDoc) {
      augmentedDecorators.push(
        `@@doc(${tspOperationGroupName}.\`${operationName}\`::parameters.${templateName}, "${bodyParam.language.default.description}");`,
      );
    }
  }
  return [augmentedDecorators, clientDecorators];
}

function buildNewArmOperation(
  resourceMetadata: ArmResource,
  operation: _ArmResourceOperation,
  swaggerOperation: Operation,
  kind: TspArmOperationType,
): TspArmResourceOperationBase {
  const { baseParameters, parameters } = buildOperationParameters(swaggerOperation, resourceMetadata);
  return {
    doc: operation.Description,
    kind,
    name: getOperationName(resourceMetadata.Name, operation.OperationID),
    resource: resourceMetadata.SwaggerModelName,
    baseParameters: baseParameters.length > 0 ? baseParameters : undefined,
    parameters: parameters.length > 0 ? parameters : undefined,
    operationId: operation.OperationID,
    examples: swaggerOperation.extensions?.["x-ms-examples"],
    clientDecorators: getOperationClientDecorators(swaggerOperation),
  };
}

const existingNames: { [resourceName: string]: Set<string> } = {};
// TO-DO: Figure out a way to create a new name if the name exists
function getOperationName(resourceName: string, operationId: string): string {
  if (!operationId) return "";

  let operationName = _.lowerFirst(_.last(operationId.split("_")));
  if (resourceName in existingNames) {
    if (existingNames[resourceName].has(operationName)) {
      operationName = _.lowerFirst(
        operationId
          .split("_")
          .map((n) => _.upperFirst(n))
          .join(""),
      );
    }
    existingNames[resourceName].add(operationName);
  } else {
    existingNames[resourceName] = new Set<string>([operationName]);
  }
  return operationName;
}

function getOperationGroupName(name: string | undefined): string {
  if (name && name.includes("_")) {
    return _.first(name.split("_"))!;
  } else {
    return "";
  }
}

function buildOperationParameters(
  operation: Operation,
  resource: ArmResource,
): { baseParameters: string[]; parameters: TypespecParameter[] } {
  const codeModel = getSession().model;
  const otherParameters: TypespecParameter[] = [];
  const pathParameters = [];
  resource.GetOperations[0].Path.split("/").forEach((p) => {
    if (p.match(/^{.+}$/)) {
      pathParameters.push(p.replace("{", "").replace("}", ""));
    }
  });
  pathParameters.push("api-version");
  pathParameters.push("$host");
  if (operation.parameters) {
    for (const parameter of operation.parameters) {
      if (resource.IsSingletonResource && parameter.schema.type === SchemaType.Constant) {
        continue;
      }
      if (!pathParameters.includes(parameter.language.default.serializedName)) {
        otherParameters.push(transformParameter(parameter, codeModel));
      }
    }
  }

  // By default we don't need any base parameters.
  const parameterTemplate: string[] = [];
  if (resource.IsExtensionResource) {
    parameterTemplate.push(getFullyQualifiedName("ExtensionBaseParameters"));
  } else if (resource.IsTenantResource) {
    parameterTemplate.push(getFullyQualifiedName("TenantBaseParameters"));
  } else if (resource.IsSubscriptionResource) {
    parameterTemplate.push(getFullyQualifiedName("SubscriptionBaseParameters"));
  }

  return {
    baseParameters: parameterTemplate,
    parameters: otherParameters,
  };
}

function getKeyParameter(resourceMetadata: ArmResource): Parameter | undefined {
  for (const operationGroup of getSession().model.operationGroups) {
    for (const operation of operationGroup.operations) {
      if (operation.operationId === resourceMetadata.GetOperations[0].OperationID) {
        for (const parameter of operation.parameters ?? []) {
          if (parameter.language.default.serializedName === resourceMetadata.ResourceKey) {
            return parameter;
          }
        }
      }
    }
  }
}

function generateSingletonKeyParameter(): TypespecParameter {
  return {
    kind: "parameter",
    name: "name",
    isOptional: false,
    type: "string",
    location: "path",
    serializedName: "name",
  };
}

function getParentResource(schema: ArmResourceSchema): TspArmResource | undefined {
  const resourceParent = schema.resourceMetadata.Parents?.[0];

  if (!resourceParent || isFirstLevelResource(resourceParent)) {
    return undefined;
  }

  for (const objectSchema of getSession().model.schemas.objects ?? []) {
    if (!isResourceSchema(objectSchema)) {
      continue;
    }

    if (objectSchema.resourceMetadata.Name === resourceParent) {
      return transformTspArmResource(objectSchema);
    }
  }
}

function getResourceKind(schema: ArmResourceSchema): ArmResourceKind {
  if (schema.resourceMetadata.IsExtensionResource) {
    return "ExtensionResource";
  }

  if (schema.resourceMetadata.IsTrackedResource) {
    return "TrackedResource";
  }

  return "ProxyResource";
}

function buildKeyExpression(schema: ArmResourceSchema, keyProperty: TypespecObjectProperty): string {
  const namePattern = keyProperty.decorators?.find((d) => d.name === "pattern")?.arguments?.[0];
  const keyName = keyProperty.decorators?.find((d) => d.name === "key")?.arguments?.[0];
  const segmentName = keyProperty.decorators?.find((d) => d.name === "segment")?.arguments?.[0];
  return `...ResourceNameParameter<
    Resource = ${schema.resourceMetadata.SwaggerModelName}
    ${keyName ? `, KeyName = "${keyName}"` : ""}
    ${segmentName ? `, SegmentName = "${segmentName}"` : ""},
    NamePattern = ${namePattern ? `"${namePattern}"` : `""`}
    ${keyProperty.type !== "string" ? `, Type = ${keyProperty.type}` : ""}
  >`;
}

function buildKeyAugmentDecorators(
  schema: ArmResourceSchema,
  keyProperty: TypespecObjectProperty,
): TypespecDecorator[] | undefined {
  return keyProperty.decorators
    ?.filter((d) => !["pattern", "key", "segment", "path"].includes(d.name))
    .filter((d) => !(d.name === "visibility" && d.arguments?.[0] === "read"))
    .map((d) => {
      d.target = `${schema.resourceMetadata.SwaggerModelName}.name`;
      return d;
    })
    .concat({
      name: "doc",
      target: `${schema.resourceMetadata.SwaggerModelName}.name`,
      arguments: [generateDocsContent(keyProperty)],
    });
}

function buildPropertiesAugmentDecorators(schema: ArmResourceSchema, propertiesModel: Property): TypespecDecorator[] {
  return [
    {
      name: "doc",
      target: `${schema.resourceMetadata.SwaggerModelName}.properties`,
      arguments: [generateDocsContent({ doc: propertiesModel?.language.default.description })],
    },
  ];
}

function buildKeyProperty(schema: ArmResourceSchema): TypespecObjectProperty {
  let parameter;
  if (!schema.resourceMetadata.IsSingletonResource) {
    const keyProperty = getKeyParameter(schema.resourceMetadata);
    if (!keyProperty) {
      throw new Error(
        `Failed to find key property ${schema.resourceMetadata.ResourceKey} for ${schema.language.default.name}`,
      );
    }
    parameter = transformParameter(keyProperty, getSession().model);
  } else {
    parameter = generateSingletonKeyParameter();
  }

  if (!parameter.decorators) {
    parameter.decorators = [];
  }

  parameter.decorators.push(
    {
      name: "key",
      arguments: [
        schema.resourceMetadata.IsSingletonResource
          ? singular(schema.resourceMetadata.ResourceKeySegment)
          : schema.resourceMetadata.ResourceKey,
      ],
    },
    {
      name: "segment",
      arguments: [schema.resourceMetadata.ResourceKeySegment],
    },
    {
      name: "visibility",
      arguments: ["read"],
    },
  );

  // remove @path decorator for key parameter
  // TODO: still under discussion with TSP team about this behavior, in order to keep generated swagger good, comment out for now
  // parameter.decorators = parameter.decorators.filter((d) => d.name !== "path");

  // by convention the property itself needs to be called "name"
  parameter.name = "name";

  return { ...parameter, kind: "property" };
}

function buildResourceDecorators(schema: ArmResourceSchema): TypespecDecorator[] {
  const resourceModelDecorators: TypespecDecorator[] = [];

  if (schema.resourceMetadata.IsSingletonResource) {
    resourceModelDecorators.push({
      name: "singleton",
      arguments: [getSingletonName(schema)],
    });
  }

  if (schema.resourceMetadata.IsTenantResource) {
    resourceModelDecorators.push({
      name: "tenantResource",
    });
  } else if (schema.resourceMetadata.IsSubscriptionResource) {
    resourceModelDecorators.push({
      name: "subscriptionResource",
    });
  }

  return resourceModelDecorators;
}

function buildResourceClientDecorators(schema: ArmResourceSchema): TypespecDecorator[] {
  const clientDecorator: TypespecDecorator[] = [];
  if (schema.language.csharp?.name) {
    clientDecorator.push(createCSharpNameDecorator(schema));
  }

  return clientDecorator;
}

function getSingletonName(schema: ArmResourceSchema): string {
  const key = schema.resourceMetadata.ResourceKey;
  const pathLast = schema.resourceMetadata.GetOperations[0].Path.split("/").pop() ?? "";
  if (key !== pathLast) {
    if (pathLast?.includes("{")) {
      // this is from c# config, which need confirm with service
      return "default";
    } else {
      return pathLast;
    }
  }
  return key;
}

function getLocationParent(schema: ArmResourceSchema): string | undefined {
  if (schema.resourceMetadata.GetOperations[0].Path.includes("/locations/")) {
    if (schema.resourceMetadata.IsTenantResource) {
      return "TenantLocationResource";
    } else if (schema.resourceMetadata.IsSubscriptionResource) {
      return "SubscriptionLocationResource";
    } else if (schema.resourceMetadata.Parents?.[0] === "ResourceGroupResource") {
      return "ResourceGroupLocationResource";
    }
  }
}
