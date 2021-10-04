import {
  CodeModel,
  ObjectSchema,
  isObjectSchema,
  SchemaType,
  Property,
  ParameterLocation,
  Parameter,
  VirtualParameter,
  getAllProperties,
  ImplementationLocation,
  Request,
} from "@autorest/codemodel";
import { Session } from "@autorest/extension-base";
import { ModelerFourOptions } from "../modeler/modelerfour-options";
import { isDefined } from "../utils";

const xmsThreshold = "x-ms-payload-flattening-threshold";
const xmsFlatten = "x-ms-client-flatten";
const isCurrentlyFlattening = "x-ms-flattening";
const hasBeenFlattened = "x-ms-flattened";

export class Flattener {
  codeModel: CodeModel;
  options: ModelerFourOptions = {};
  threshold = 0;
  recursePayload = false;

  constructor(protected session: Session<CodeModel>) {
    this.codeModel = session.model; // shadow(session.model, filename);
  }

  async init() {
    // get our configuration for this run.
    this.options = await this.session.getValue("modelerfour", {});
    this.threshold = await this.session.getValue("payload-flattening-threshold", 0);
    this.recursePayload = await this.session.getValue("recursive-payload-flattening", false);
    return this;
  }

  *getFlattenedParameters(
    parameter: Parameter,
    property: Property,
    path: Array<Property> = [],
  ): Iterable<VirtualParameter> {
    if (property.readOnly) {
      // skip read-only properties
      return;
    }
    if (isObjectSchema(property.schema) && this.recursePayload === true) {
      for (const child of getAllProperties(<ObjectSchema>property.schema)) {
        yield* this.getFlattenedParameters(parameter, child, [...path, property]);
      }
    } else {
      const vp = new VirtualParameter(
        property.language.default.name,
        property.language.default.description,
        property.schema,
        {
          ...property,
          implementation: ImplementationLocation.Method,
          originalParameter: parameter,
          targetProperty: property,
          pathToProperty: path,
        },
      );
      delete (<any>vp).serializedName;
      delete (<any>vp).readOnly;
      delete (<any>vp).isDiscriminator;
      delete (<any>vp).flattenedNames;

      // if the parameter has "x-ms-parameter-grouping" extension, (and this is a top level parameter) then we should copy that to the vp.
      if (path.length === 0 && parameter.extensions?.["x-ms-parameter-grouping"]) {
        (vp.extensions = vp.extensions || {})["x-ms-parameter-grouping"] =
          parameter.extensions?.["x-ms-parameter-grouping"];
      }

      yield vp;
    }
    // ·
  }
  /**
   * This flattens an request's parameters (ie, takes the parameters from an operation and if they are objects will attempt to create inline versions of them)
   */
  flattenPayload(request: Request, parameter: Parameter, schema: ObjectSchema) {
    // hide the original parameter
    parameter.flattened = true;

    for (const property of getAllProperties(schema)) {
      if (property.readOnly) {
        // skip read-only properties
        continue;
      }
      for (const vp of this.getFlattenedParameters(parameter, property)) {
        request.parameters?.push(vp);
      }
    }
  }

  /**
   * This will flatten models that are marked 'x-ms-client-flatten'
   * @param schema schema to recursively flatten
   */
  flattenSchema(schema: ObjectSchema) {
    const state = schema.extensions?.[isCurrentlyFlattening];

    if (state === false) {
      // already done.
      return;
    }

    if (state === true) {
      // in progress.
      throw new Error(
        `Circular reference encountered during processing of x-ms-client flatten ('${schema.language.default.name}')`,
      );
    }

    // hasn't started yet.
    schema.extensions = schema.extensions || {};
    schema.extensions[isCurrentlyFlattening] = true;

    // ensure that parent schemas are done first -- this should remove
    // the problem when the order isn't just right.
    for (const parent of schema.parents?.immediate ?? []) {
      if (isObjectSchema(parent)) {
        this.flattenSchema(parent);
      }
    }

    if (schema.properties) {
      for (const [index, property] of [...schema.properties.entries()].reverse()) {
        if (isObjectSchema(property.schema) && property.extensions?.[xmsFlatten]) {
          // first, ensure tha the child is pre-flattened
          this.flattenSchema(property.schema);

          // remove that property from the scheama
          schema.properties.splice(index, 1);

          // copy all of the properties from the child into this
          // schema
          for (const childProperty of getAllProperties(property.schema)) {
            schema.addProperty(
              new Property(
                childProperty.language.default.name,
                childProperty.language.default.description,
                childProperty.schema,
                {
                  ...childProperty,
                  flattenedNames: [
                    property.serializedName,
                    ...(childProperty.flattenedNames ? childProperty.flattenedNames : [childProperty.serializedName]),
                  ],
                  required: property.required && childProperty.required,
                  nullable: property.nullable ?? childProperty.nullable,
                },
              ),
            );
          }

          // remove the extension
          delete property.extensions[xmsFlatten];
          if (Object.keys(property.extensions ?? {}).length === 0) {
            delete property["extensions"];
          }
          // and mark the child class as 'do-not-generate' ?
          (property.schema.extensions = property.schema.extensions || {})[hasBeenFlattened] = true;
        }
      }
    }

    schema.extensions[isCurrentlyFlattening] = false;
  }

  public process() {
    // support 'x-ms-payload-flattening-threshold'  per-operation
    // support '--payload-flattening-threshold:X' global setting

    if (this.options["flatten-models"] === true) {
      this.flattenModels();
    }
    if (this.options["flatten-payloads"] === true) {
      this.flattenPayloads();
    }

    return this.codeModel;
  }

  private flattenModels() {
    for (const schema of this.codeModel.schemas.objects ?? []) {
      this.flattenSchema(schema);
    }
    if (!this.options["keep-unused-flattened-models"]) {
      this.removeUnusedFlattenModels();
    }

    for (const schema of this.codeModel.schemas.objects ?? []) {
      if (schema.extensions) {
        delete schema.extensions[isCurrentlyFlattening];
        // don't want this until I have removed the unreferenced models.
        // delete schema.extensions[hasBeenFlattened];
        if (schema.extensions && Object.keys(schema.extensions).length === 0) {
          delete schema["extensions"];
        }
      }
    }
  }

  private removeUnusedFlattenModels() {
    if (!this.codeModel.schemas.objects) {
      return;
    }

    const objects: Array<ObjectSchema | undefined> = this.codeModel.schemas.objects;
    let dirty = false;
    do {
      // reset on every pass
      dirty = false;
      // remove unreferenced models
      for (const [index, schema] of objects.entries()) {
        if (schema === undefined) {
          continue;
        }
        // only remove unreferenced models that have been flattened.
        if (!schema.extensions?.[hasBeenFlattened]) {
          continue;
        }

        if (schema.discriminatorValue || schema.discriminator) {
          // it's polymorphic -- I don't think we can remove this
          continue;
        }

        if (schema.children?.all || schema.parents?.all) {
          // it's got either a parent or child schema.
          continue;
        }

        if (!this.isReferencedByOthers(schema)) {
          objects[index] = undefined;
          dirty = true;
        }
      }
    } while (dirty);

    this.codeModel.schemas.objects = objects.filter(isDefined);
  }

  private isReferencedByOthers(schema: ObjectSchema) {
    let count = 0;
    return find(
      this.codeModel,
      (obj) => {
        if (obj === schema) {
          count++;
          if (count > 1) {
            return true;
          }
        }
        return false;
      },
      new WeakSet<object>(),
    );
  }

  private flattenPayloads() {
    /**
     * BodyParameter Payload Flattening
     *
     * A body parameter is flattened (one level) when:
     *
     *  - the body parameter schema is an object
     *  - the body parameter schema is not polymorphic (is this true?)
     *
     *
     *
     *  and one of:
     *  - the body parameter has x-ms-client-flatten: true
     *  - the operation has x-ms-payload-flattening-threshold greater than zero and the property count in the body parameter is lessthan or equal to that.
     *  - the global configuration option payload-flattening-threshold is greater than zero and the property count in the body parameter is lessthan or equal to that
     *
     */

    // flatten payloads

    for (const group of this.codeModel.operationGroups) {
      for (const operation of group.operations) {
        // when there are multiple requests in an operation
        // and the generator asks not to flatten them
        if (
          operation.requests &&
          operation.requests.length > 1 &&
          this.options["multiple-request-parameter-flattening"] === false
        ) {
          continue;
        }

        for (const request of operation.requests ?? []) {
          const body = request.parameters?.find(
            (p) => p.protocol.http?.in === ParameterLocation.Body && p.implementation === ImplementationLocation.Method,
          );

          if (body && isObjectSchema(body.schema)) {
            const schema = <ObjectSchema>body.schema;
            if (schema.discriminator) {
              // skip flattening on polymorphic payloads, since you don't know the actual type.
              continue;
            }

            let flattenOperationPayload = body?.extensions?.[xmsFlatten];
            if (flattenOperationPayload === false) {
              // told not to explicitly.
              continue;
            }

            if (!flattenOperationPayload) {
              const threshold = <number>operation.extensions?.[xmsThreshold] ?? this.threshold;
              if (threshold > 0) {
                // get the count of the (non-readonly) properties in the schema
                flattenOperationPayload =
                  [...getAllProperties(schema)].filter(
                    (property) => property.readOnly !== true && property.schema.type !== SchemaType.Constant,
                  ).length <= threshold;
              }
            }

            if (flattenOperationPayload) {
              this.flattenPayload(request, body, schema);
              request.updateSignatureParameters();
            }
          }
        }
      }
    }
  }
}

function find(instance: any, visitor: (item: any) => boolean, visited: WeakSet<object>): boolean {
  if (instance === null || instance === undefined || visited.has(instance)) {
    return false;
  }
  visited.add(instance);

  if (instance instanceof Set || Array.isArray(instance)) {
    for (const each of instance) {
      if (typeof each === "object") {
        if (find(each, visitor, visited)) {
          return true;
        }
      }
      if (visitor(each)) {
        return true;
      }
    }
    return false;
  }

  if (instance instanceof Map) {
    // walk thru map members.
    for (const [key, value] of instance.entries()) {
      if (typeof value === "object") {
        if (find(value, visitor, visited)) {
          return true;
        }
      }
      // yield the member after visiting children
      if (visitor(value)) {
        return true;
      }
    }
    return false;
  }

  // objects
  for (const key of Object.keys(instance)) {
    const value = instance[key];
    if (typeof value === "object") {
      if (find(value, visitor, visited)) {
        return true;
      }
    }
    // yield the member after visiting children
    if (visitor(value)) {
      return true;
    }
  }
  return false;
}
