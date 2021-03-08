import {
  CodeModel,
  Schema,
  GroupSchema,
  isObjectSchema,
  SchemaType,
  GroupProperty,
  ParameterLocation,
  Operation,
  Parameter,
  VirtualParameter,
  getAllProperties,
  ImplementationLocation,
  OperationGroup,
  Request,
  SchemaContext,
} from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { values, items, length, Dictionary, refCount, clone } from "@azure-tools/linq";
import { pascalCase, camelCase } from "@azure-tools/codegen";
import { ModelerFourOptions } from "../modeler/modelerfour-options";

const mergeReponseHeaders = "merge-response-headers";
const xmsParameterGrouping = "x-ms-parameter-grouping";

export class Grouper {
  codeModel: CodeModel;
  options: ModelerFourOptions = {};
  groups: Dictionary<GroupSchema> = {};

  constructor(protected session: Session<CodeModel>) {
    this.codeModel = session.model; // shadow(session.model, filename);
  }

  async init() {
    // get our configuration for this run.
    this.options = await this.session.getValue("modelerfour", {});
    return this;
  }

  process() {
    if (this.options["group-parameters"] === true) {
      for (const group of this.codeModel.operationGroups) {
        for (const operation of group.operations) {
          for (const request of values(operation.requests)) {
            this.processParameterGroup(group, operation, request);
            request.updateSignatureParameters();
          }
          operation.updateSignatureParameters();
        }
      }
    }
    /*
        if (this.options[mergeReponseHeaders] === true) {

          for (const group of this.codeModel.operationGroups) {
            for (const operation of group.operations) {
              this.processResponseHeaders(operation);
              operation.request.updateSignatureParameters();
            }
          }
        }
        */
    return this.codeModel;
  }

  proposedName(group: OperationGroup, operation: Operation, parameter: Parameter) {
    const xmsp = parameter.extensions?.[xmsParameterGrouping];
    if (xmsp.name && typeof xmsp.name === "string") {
      return xmsp.name;
    }

    const postfix = xmsp.postfix && typeof xmsp.postfix === "string" ? xmsp.postfix : "Parameters";

    return pascalCase(`${group.$key} ${operation.language.default.name} ${postfix}`);
  }

  processParameterGroup(group: OperationGroup, operation: Operation, request: Request) {
    const grouped = [...(operation.parameters ?? []), ...(request.parameters ?? [])].filter(
      (parameter) =>
        parameter.extensions?.[xmsParameterGrouping] &&
        !(parameter.schema.type === SchemaType.Constant && parameter.required) &&
        parameter.implementation !== ImplementationLocation.Client,
    );

    if (grouped.length > 0) {
      // create a parameter group object schema for the selected parameters.
      const addedGroupedParameters = new Map<GroupSchema, Parameter>();

      for (const parameter of grouped) {
        const groupName = this.proposedName(group, operation, parameter);

        // see if we've started the schema for this yet.
        if (!this.groups[groupName]) {
          // create a new object schema for this group
          const schema = new GroupSchema(groupName, "Parameter group");
          schema.usage = [SchemaContext.Input];
          this.groups[groupName] = schema;
          this.codeModel.schemas.add(schema);
        }
        const schema = this.groups[groupName];

        // see if the group has this parameter.
        const existingProperty = values(schema.properties).first(
          (each) => each.language.default.name === parameter.language.default.name,
        );
        if (existingProperty) {
          // we have a property by this name one already
          // mark the groupproperty with this parameter (so we can find it if needed)
          existingProperty.originalParameter.push(parameter);
        } else {
          // create a property for this parameter.
          const gp = new GroupProperty(
            parameter.language.default.name,
            parameter.language.default.description,
            parameter.schema,
            {
              required: parameter.required,
            },
          );
          gp.originalParameter.push(parameter);
          schema.add(gp);
        }

        // check if this groupSchema has been added as a parameter for this operation yet.
        if (!addedGroupedParameters.has(schema)) {
          addedGroupedParameters.set(
            schema,
            request.addParameter(
              new Parameter(camelCase(schema.language.default.name), schema.language.default.description, schema, {
                implementation: ImplementationLocation.Method,
              }),
            ),
          );
        }

        // make sure that it's not optional if any parameter are not optional.
        const pp = <Parameter>addedGroupedParameters.get(schema);
        pp.required = pp.required || parameter.required;

        // mark the original parameter with the target of the grouping.
        parameter.groupedBy = pp;

        // remove the grouping extension from the original parameter.
        if (parameter.extensions) {
          delete parameter.extensions[xmsParameterGrouping];
          if (length(parameter.extensions) === 0) {
            delete parameter["extensions"];
          }
        }
      }
    }
  }

  processResponseHeaders(operation: Operation) {
    throw new Error("Method not implemented.");
  }
}
