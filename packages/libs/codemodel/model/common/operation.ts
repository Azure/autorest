import { Parameter, ImplementationLocation } from "./parameter";
import { Response } from "./response";
import { Metadata } from "./metadata";
import { Aspect } from "./aspect";
import { ApiVersion } from "./api-version";
import { Dictionary, values } from "@azure-tools/linq";
import { DeepPartial } from "@azure-tools/codegen";
import { SchemaType } from "./schema-type";

/** represents a single callable endpoint with a discrete set of inputs, and any number of output possibilities (responses or exceptions)  */
export interface Operation extends Aspect {
  /** common parameters when there are multiple requests */
  parameters?: Array<Parameter>;

  /** a common filtered list of parameters that is (assumably) the actual method signature parameters */
  signatureParameters?: Array<Parameter>;

  /** the different possibilities to build the request. */
  requests?: Array<Request>;

  /** responses that indicate a successful call */
  responses?: Array<Response>;

  /** responses that indicate a failed call */
  exceptions?: Array<Response>;

  /** the apiVersion to use for a given profile name */
  profile?: Dictionary<ApiVersion>;
}

export interface Request extends Metadata {
  /** the parameter inputs to the operation */
  parameters?: Array<Parameter>;

  /** a filtered list of parameters that is (assumably) the actual method signature parameters */
  signatureParameters?: Array<Parameter>;
}

export class Request extends Metadata implements Request {
  constructor(initializer?: DeepPartial<Request>) {
    super();
    this.apply(initializer);
  }

  addParameter(parameter: Parameter) {
    (this.parameters = this.parameters || []).push(parameter);
    this.updateSignatureParameters();
    return parameter;
  }

  updateSignatureParameters() {
    if (this.parameters) {
      this.signatureParameters = values(this.parameters)
        .where(
          (each) =>
            each.schema.type !== SchemaType.Constant &&
            each.implementation !== ImplementationLocation.Client &&
            !each.groupedBy &&
            !each.flattened,
        )
        .toArray();
    }
  }
}
export class Operation extends Aspect implements Operation {
  constructor($key: string, description: string, initializer?: DeepPartial<Operation>) {
    super($key, description);
    this.apply(initializer);
  }

  /** add a request to the operation */
  addRequest(request: Request) {
    (this.requests = this.requests || []).push(request);
    return request;
  }

  addParameter(parameter: Parameter) {
    (this.parameters = this.parameters || []).push(parameter);
    this.updateSignatureParameters();
    return parameter;
  }

  updateSignatureParameters() {
    if (this.parameters) {
      this.signatureParameters = values(this.parameters)
        .where(
          (each) =>
            each.schema.type !== SchemaType.Constant &&
            each.implementation !== ImplementationLocation.Client &&
            !each.groupedBy &&
            !each.flattened,
        )
        .toArray();
    }
  }

  addResponse(response: Response) {
    (this.responses = this.responses || []).push(response);
    return response;
  }
  addException(exception: Response) {
    (this.exceptions = this.exceptions || []).push(exception);
    return exception;
  }
  addProfile(profileName: string, apiVersion: ApiVersion) {
    (this.profile = this.profile || {})[profileName] = apiVersion;
    return this;
  }
}

/** an operation group represents a container around set of operations */
export interface OperationGroup extends Metadata {
  $key: string;
  operations: Array<Operation>;
}

export class OperationGroup extends Metadata implements OperationGroup {
  constructor(name: string, objectInitializer?: DeepPartial<OperationGroup>) {
    super();
    this.$key = name;
    this.apply(objectInitializer);
    this.language.default.name = name;
  }

  addOperation(operation: Operation) {
    (this.operations = this.operations || []).push(operation);
    return operation;
  }
}
