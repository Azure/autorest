import {
  AnySchema,
  CodeModel,
  HttpHeader,
  HttpResponse,
  Operation,
  OperationGroup,
  Response,
  Schema,
  SetType,
} from "@autorest/codemodel";
import {
  getDoc,
  ModelTypeProperty,
  NamespaceType,
  OperationType,
  Program,
  throwDiagnostic,
  Type,
} from "@azure-tools/adl";
import { getHeaderFieldName, getResources, getServiceTitle, isBody } from "@azure-tools/adl-rest";

export class ADLModeler {
  private model: CodeModel;
  private _anySchema: AnySchema | undefined;
  public constructor(private program: Program) {
    this.model = new CodeModel(getServiceTitle(program));
  }

  public process(): CodeModel {
    for (const resource of getResources(this.program)) {
      if (resource.kind !== "Namespace") {
        throwDiagnostic("Resource goes on namespace", resource);
      }

      this.processResource(resource as NamespaceType);
    }

    return this.model;
  }

  private processResource(resource: NamespaceType) {
    const operationGroup = this.model.getOperationGroup(resource.name);

    for (const [name, adlOperation] of resource.operations.entries()) {
      this.processOperation(name, adlOperation, operationGroup);
    }
  }

  private processOperation(name: string, adlOperation: OperationType, operationGroup: OperationGroup) {
    const operation = new Operation(name, getDoc(this.program, adlOperation), {});
    operationGroup.addOperation(operation);
  }

  private processOperationResponses(operation: Operation, adlOperation: OperationType) {
    const responseType = adlOperation.returnType;
    if (responseType.kind === "Union") {
      for (const [i, option] of responseType.options.entries()) {
        operation.addResponse(this.getResponse(option));
      }
    } else {
      operation.addResponse(this.getResponse(responseType));
    }
  }

  private getResponse(responseModel: Type) {
    if (
      responseModel.kind === "Model" &&
      responseModel.baseModels.length === 0 &&
      responseModel.properties.size === 0
    ) {
      return new Response({
        language: { default: { description: "Null response" } },
      });
    }

    let bodyModel = responseModel;
    const response = new Response({});
    let statusCode = "200";
    let contentType = "application/json";
    const headers: HttpHeader[] = [];

    if (responseModel.kind === "Model") {
      for (const prop of responseModel.properties.values()) {
        if (isBody(this.program, prop)) {
          if (bodyModel !== responseModel) {
            throwDiagnostic("Duplicate @body declarations on response type", responseModel);
          }

          bodyModel = prop.type;
        }
        const type = prop.type;
        const headerName = getHeaderFieldName(this.program, prop);
        switch (headerName) {
          case undefined:
            break;
          case "status-code":
            if (type.kind === "Number") {
              statusCode = String(type.value);
            }
            break;
          case "content-type":
            if (type.kind === "String") {
              contentType = type.value;
            }
            break;
          default:
            headers.push(this.getResponseHeader(prop));
            break;
        }
      }
    }

    response.protocol.http = SetType(HttpResponse, {
      statusCodes: [statusCode],
      headers: headers.length ? headers : undefined,
    });

    return response;
  }

  private getResponseHeader(prop: ModelTypeProperty): HttpHeader {
    return new HttpHeader(prop.name, this.getSchema(prop.type));
  }

  private getSchema(type: Type): Schema {
    return this.anySchema;
  }

  private get anySchema(): AnySchema {
    return this._anySchema ?? (this._anySchema = this.model.schemas.add(new AnySchema("Anything")));
  }
}
