/* eslint-disable no-useless-escape */
import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  Transformer,
  QuickDataSource,
  JsonPath,
  Source,
} from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { PipelinePlugin } from "../../pipeline/common";
import { values, length } from "@azure-tools/linq";
import { createHash } from "crypto";
import { SchemaStats } from "../../stats";
import { includeXDashProperties } from "@azure-tools/openapi";
import { parseJsonPointer } from "@azure-tools/json";

/**
 * parses a json pointer, and inserts a string into the returned array
 * the string is a hashed value of the pointer itself
 *
 * this resolves potential collisions that occur when the code that creates identity of a shaken element
 * drops non-alphanumeric characters, and there are strings that are too similar
 *
 * It's placed after the second element because the elements after that can be used
 * to synthesize a client name, and if it's placed earlier, it's too significant
 * when trying to manually look thru a processes OAI file.
 */
function hashedJsonPointer(p: string) {
  const result = parseJsonPointer(p);
  result.splice(1, 0, createHash("md5").update(p).digest().readUInt32BE(0).toString(36));
  return result;
}

const methods = new Set(["get", "put", "post", "delete", "options", "head", "patch", "trace"]);

export class OAI3Shaker extends Transformer<AnyObject, AnyObject> {
  public stats: SchemaStats = {
    anonymous: 0,
    namedSchema: 0,
    namedSchemaInline: 0,

    get total() {
      return this.anonymous + this.namedSchema + this.namedSchemaInline;
    },
  };

  constructor(originalFile: Source, private isSimpleTreeShake: boolean) {
    super([originalFile]);
  }

  private docServers?: Array<AnyObject>;
  private pathServers?: Array<AnyObject>;
  private pathParameters?: Array<AnyObject>;
  private operationServers?: Array<AnyObject>;

  get servers() {
    // it's not really clear according to OAI3 spec, but I'm going to assume that
    // a servers entry at a given level, replaces a servers entry at an earlier level.
    return this.operationServers || this.pathServers || this.docServers || [];
  }

  get components(): AnyObject {
    if (this.generated.components) {
      return this.generated.components;
    }
    if (this.current.components) {
      return this.newObject(this.generated, "components", "/components");
    }
    return this.newObject(this.generated, "components", "/");
  }

  private componentItem(key: string) {
    return this.components[key]
      ? this.components[key]
      : this.current.components && this.current.components[key]
      ? this.newObject(this.components, key, `/components/${key}`)
      : this.newObject(this.components, key, "/");
  }

  get schemas(): AnyObject {
    return this.componentItem("schemas");
  }
  get responses(): AnyObject {
    return this.componentItem("responses");
  }
  get parameters(): AnyObject {
    return this.componentItem("parameters");
  }
  get examples(): AnyObject {
    return this.componentItem("examples");
  }
  get requestBodies(): AnyObject {
    return this.componentItem("requestBodies");
  }
  get headers(): AnyObject {
    return this.componentItem("headers");
  }
  get securitySchemes(): AnyObject {
    return this.componentItem("securitySchemes");
  }
  get links(): AnyObject {
    return this.componentItem("links");
  }
  get callbacks(): AnyObject {
    return this.componentItem("callbacks");
  }

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    // split out servers first.
    const [servers, theNodes] = values(originalNodes).bifurcate((each) => each.key === "servers");

    // set the doc servers
    servers.forEach((s) => (this.docServers = s.value));

    // Order in which the openapi properties should be tree shaked.
    // Components needs to go first so other tree shaked element don't interfer with actual models.
    const elementOrder = ["components", "paths", "x-ms-paths"].reverse();
    const sortedNodes = theNodes.sort((a, b) => {
      return elementOrder.indexOf(b.key) - elementOrder.indexOf(a.key);
    });
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of sortedNodes) {
      switch (key) {
        case "x-ms-paths":
        case "paths":
          this.visitPaths(this.newObject(targetParent, key, pointer), children);
          break;

        case "components":
          this.visitComponents(this.components, children);
          break;

        case "x-ms-metadata":
        case "x-ms-secondary-file":
        case "info":
          this.clone(targetParent, key, pointer, value);
          break;

        // copy these over without worrying about moving things down to components.
        default:
          if (!this.current["x-ms-secondary-file"]) {
            this.clone(targetParent, key, pointer, value);
          }
          break;
      }
    }

    if (this.docServers !== undefined) {
      this.clone(targetParent, "servers", "/servers", this.docServers);
    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { key, pointer, children } of nodes) {
      // each path
      this.visitPath(this.newObject(targetParent, key, pointer), children);
    }
  }

  visitPath(targetParent: AnyObject, nodes: Iterable<Node>) {
    // split out the servers first.
    const [servers, someNodes] = values(nodes).bifurcate((each) => each.key === "servers");

    const [parameters, theNodes] = values(someNodes).bifurcate((each) => each.key === "parameters");
    if (length(parameters) > 0) {
      this.pathParameters = [];
      for (const { value, key, pointer, children } of parameters) {
        this.pathParameters.push(...children);
      }
    }

    // set the operationServers if they exist.
    servers.forEach((s) => (this.pathServers = s.value));

    // handle the rest.
    for (const { value, key, pointer, children } of theNodes) {
      switch (key) {
        case "get":
        case "put":
        case "post":
        case "delete":
        case "options":
        case "head":
        case "patch":
        case "trace":
          this.visitHttpOperation(this.newObject(targetParent, key, pointer), children);
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }

    // reset at end
    this.pathServers = undefined;
    this.pathParameters = undefined;
  }

  visitHttpOperation(targetParent: AnyObject, nodes: Iterable<Node>) {
    // split out the servers first.
    const [servers, theNodes] = values(nodes).bifurcate((each) => each.key === "servers");

    // set the operationServers if they exist.
    servers.forEach((s) => (this.operationServers = s.value));

    this.clone(targetParent, "servers", "/", this.servers);

    let newArray = length(this.pathParameters) > 0 ? this.newArray(targetParent, "parameters", "") : undefined;
    if (newArray) {
      for (const child of this.pathParameters ?? []) {
        const p = this.dereference(
          "/components/parameters",
          this.parameters,
          this.visitParameter,
          newArray,
          child.key,
          child.pointer,
          child.value,
          child.children,
        );
        // tag it as a method parameter. (default is 'client', so we have to tag it when we move it.)
        if (!child.value.$ref && p["x-ms-parameter-location"] === undefined) {
          p["x-ms-parameter-location"] = { value: "method", pointer: "" };
        }
      }
    }

    for (const { value, key, pointer, children } of theNodes) {
      switch (key) {
        case "parameters":
          {
            // parameters are a small special case, because they have to be tweaked when they are moved to the global parameter section.
            newArray = newArray || this.newArray(targetParent, key, pointer);

            for (const child of children) {
              const p = this.dereference(
                "/components/parameters",
                this.parameters,
                this.visitParameter,
                newArray,
                length(this.pathParameters) + child.key,
                child.pointer,
                child.value,
                child.children,
              );
              // tag it as a method parameter. (default is 'client', so we have to tag it when we move it.)
              if (!child.value.$ref && p["x-ms-parameter-location"] === undefined) {
                p["x-ms-parameter-location"] = { value: "method", pointer: "" };
              }
            }
          }
          break;

        case "requestBody":
          this.dereference(
            "/components/requestBodies",
            this.requestBodies,
            this.visitRequestBody,
            targetParent,
            key,
            pointer,
            value,
            children,
          );
          break;
        case "responses":
          this.dereferenceItems(
            "/components/responses",
            this.responses,
            this.visitResponse,
            this.newObject(targetParent, key, pointer),
            children,
          );
          break;
        case "callbacks":
          this.dereferenceItems(
            "/components/callbacks",
            this.callbacks,
            this.visitCallback,
            this.newObject(targetParent, key, pointer),
            children,
          );
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }

    // reset at end
    this.operationServers = undefined;
  }

  visitParameter(targetParent: AnyObject, nodes: Iterable<Node>) {
    const [requiredNodes, theOtherNodes] = values(nodes).bifurcate((each) => each.key === "required");
    const isRequired = requiredNodes.length > 0 ? !!requiredNodes[0].value : false;
    for (const { value, key, pointer, children } of theOtherNodes) {
      switch (key) {
        case "schema":
          if (isRequired && value.enum && value.enum.length === 1) {
            // if an enum has a single value and it is required, then it's just a constant. Thus, not necessary to shake it.
            this.clone(targetParent, key, pointer, value);
            break;
          }
          this.dereference(
            "/components/schemas",
            this.schemas,
            this.visitSchema,
            targetParent,
            key,
            pointer,
            value,
            children,
          );
          break;
        case "content":
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }

    if (requiredNodes[0] !== undefined) {
      this.clone(targetParent, requiredNodes[0].key, requiredNodes[0].pointer, requiredNodes[0].value);
    }
  }

  visitSchema(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    const object = "object";
    const [requiredField, theNodes] = values(originalNodes).bifurcate((each) => each.key === "required");
    const requiredProperties = new Array<string>();
    if (requiredField[0] !== undefined) {
      requiredProperties.push(...requiredField[0].value);
    }

    for (const { value, key, pointer, children } of theNodes) {
      switch (key) {
        case "properties":
          this.visitProperties(this.newObject(targetParent, key, pointer), children, requiredProperties);
          break;

        case "additionalProperties":
          // In AutoRest V2, AdditionalProperties are not dereferenced.
          if (!this.isSimpleTreeShake && typeof value === object) {
            // it should be a schema
            this.dereference(
              "/components/schemas",
              this.schemas,
              this.visitSchema,
              targetParent,
              key,
              pointer,
              value,
              children,
            );
          } else {
            // otherwise, just copy it across.
            this.clone(targetParent, key, pointer, value);
          }
          break;

        case "allOf":
        case "anyOf":
        case "oneOf":
          if (this.isSimpleTreeShake) {
            // this is the same behavior as AutoRest V2. Inlined allOf, anyOf, oneOf are not shaken
            this.clone(targetParent, key, pointer, value);
          } else {
            const polymorphicCollection = this.newArray(targetParent, key, pointer);
            for (const { value: itemVal, children: itemChildren, pointer: itemPointer, key: itemKey } of children) {
              this.dereference(
                "/components/schemas",
                this.schemas,
                this.visitSchema,
                polymorphicCollection,
                itemKey,
                itemPointer,
                itemVal,
                itemChildren,
              );
            }
          }

          break;
        case "not":
        case "items":
          this.dereference(
            "/components/schemas",
            this.schemas,
            this.visitSchema,
            targetParent,
            key,
            pointer,
            value,
            children,
            `${this.getNameHint(pointer)}Item`,
          );
          break;

        // everything else, just copy recursively.
        default:
          if (targetParent[key] && targetParent[key] === value) {
            // properties that are already there and the same...
            break;
          }
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }

    if (requiredProperties.length > 0) {
      this.clone(targetParent, requiredField[0].key, requiredField[0].pointer, requiredProperties);
    }
  }

  visitContent(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, pointer, children } of originalNodes) {
      this.visitMediaType(this.newObject(targetParent, key, pointer), children);
    }
  }

  visitMediaType(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "schema":
          this.dereference(
            "/components/schemas",
            this.schemas,
            this.visitSchema,
            targetParent,
            key,
            pointer,
            value,
            children,
          );
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitArrayProperty(
    targetParent: AnyObject,
    key: string,
    pointer: string,
    value: AnyObject,
    children: Iterable<Node>,
    nameHint: string,
  ) {
    const t = value?.items?.type;
    if (t === "boolean" || t === "integer" || t === "number") {
      this.clone(targetParent, key, pointer, value);
    } else {
      // object or string
      this.dereference(
        "/components/schemas",
        this.schemas,
        this.visitSchema,
        targetParent,
        key,
        pointer,
        value,
        children,
        nameHint,
      );
    }
  }

  getNameHint(pointer: string): string {
    const getArrayItemPropertyNameHint = (jp: JsonPath) => {
      // a unique id using the path, skipping 'properties'
      // and converting the 'items' to 'item'.
      let nameHint = "";
      for (let i = 2; i < jp.length; i += 1) {
        if (jp[i] === "properties") {
          continue;
        }

        const part = jp[i] === "items" ? "item" : jp[i];
        nameHint += i === 2 ? `${part}` : `-${part}`;
      }
      return nameHint;
    };

    const getPropertyNameHint = (jp: JsonPath) => {
      let nameHint = "";
      for (let i = 2; i < jp.length; i += 2) {
        nameHint += i === 2 ? `${jp[i]}` : `-${jp[i]}`;
      }
      return nameHint;
    };

    const jsonPath = parseJsonPointer(pointer);
    return jsonPath[jsonPath.length - 3] === "items"
      ? getArrayItemPropertyNameHint(jsonPath)
      : getPropertyNameHint(jsonPath);
  }

  visitProperties(targetParent: AnyObject, originalNodes: Iterable<Node>, requiredProperties: Array<string>) {
    for (const { value, key, pointer, children } of originalNodes) {
      // if the property has a schema that type 'boolean' then we'll just leave it inline
      // we will leave strings, number and integer inlined only if they ask for simple-tree-shake. Also, if it's a string + enum + required + single val enum
      // reason: old modeler does not handle non-inlined string properties.
      switch (value.type) {
        case "string":
        case "integer":
        case "number":
          if (this.isSimpleTreeShake) {
            this.clone(targetParent, key, pointer, value);
          } else {
            const nameHint = this.getNameHint(pointer);
            this.dereference(
              "/components/schemas",
              this.schemas,
              this.visitSchema,
              targetParent,
              key,
              pointer,
              value,
              children,
              nameHint,
            );
          }
          break;
        case "boolean":
          this.clone(targetParent, key, pointer, value);
          break;
        case "array":
          if (this.isSimpleTreeShake) {
            this.clone(targetParent, key, pointer, value);
          } else {
            this.visitArrayProperty(targetParent, key, pointer, value, children, this.getNameHint(pointer));
          }

          break;
        default:
          {
            // inline objects had a name of '<Class><PropertyName>'
            // the dereference method will use the full path to build a name, and we should ask it to use the same thing that
            // we were using before..
            const nameHint = this.getNameHint(pointer);
            this.dereference(
              "/components/schemas",
              this.schemas,
              this.visitSchema,
              targetParent,
              key,
              pointer,
              value,
              children,
              nameHint,
              true,
            );
          }
          break;
      }
    }
  }

  visitRequestBody(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        // everything else, just copy recursively.
        case "content":
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  dereferenceItems(
    baseReferencePath: string,
    targetCollection: any,
    visitor: (tp: any, on: Iterable<Node>) => void,
    targetParent: AnyObject,
    originalNodes: Iterable<Node>,
  ) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (baseReferencePath === "/components/schemas") {
        this.stats.namedSchema++;
      }
      this.dereference(baseReferencePath, targetCollection, visitor, targetParent, key, pointer, value, children);
    }
  }

  visitComponents(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "schemas":
          this.dereferenceItems(`/components/${key}`, this.schemas, this.visitSchema, this.schemas, children);
          break;

        case "responses":
          this.dereferenceItems(`/components/${key}`, this.responses, this.visitResponse, this.responses, children);
          break;

        case "parameters":
          this.dereferenceItems(`/components/${key}`, this.parameters, this.visitParameter, this.parameters, children);
          break;

        case "examples":
          this.dereferenceItems(`/components/${key}`, this.examples, this.visitExample, this.examples, children);
          break;

        case "requestBodies":
          this.dereferenceItems(
            `/components/${key}`,
            this.requestBodies,
            this.visitRequestBody,
            this.requestBodies,
            children,
          );
          break;

        case "headers":
          this.dereferenceItems(`/components/${key}`, this.headers, this.visitHeader, this.headers, children);
          break;

        case "securitySchemes":
          this.dereferenceItems(
            `/components/${key}`,
            this.securitySchemes,
            this.visitSecurityScheme,
            this.securitySchemes,
            children,
          );
          break;

        case "links":
          this.dereferenceItems(`/components/${key}`, this.links, this.visitLink, this.links, children);
          break;

        case "callbacks":
          this.dereferenceItems(`/components/${key}`, this.callbacks, this.visitCallback, this.callbacks, children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitResponse(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "content":
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        case "headers":
          this.dereferenceItems(
            `/components/${key}`,
            this.headers,
            this.visitHeader,
            this.newObject(targetParent, key, pointer),
            children,
          );
          break;
        case "links":
          this.dereferenceItems(
            `/components/${key}`,
            this.links,
            this.visitLink,
            this.newObject(targetParent, key, pointer),
            children,
          );
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitExample(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitHeader(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "schema":
          this.dereference(
            "/components/schemas",
            this.schemas,
            this.visitSchema,
            targetParent,
            key,
            pointer,
            value,
            children,
          );
          break;
        case "content":
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitSecurityScheme(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitLink(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitCallback(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, pointer, children } of originalNodes) {
      this.visitPath(this.newObject(targetParent, key, pointer), children);
    }
  }

  dereference(
    baseReferencePath: string,
    targetCollection: AnyObject,
    visitor: (tp: any, on: Iterable<Node>) => void,
    targetParent: AnyObject,
    key: string,
    pointer: string,
    value: any,
    children: Iterable<Node>,
    nameHint?: string,
    isAnonymous = false,
  ) {
    if (value.$ref) {
      // it's a reference already.
      return this.clone(targetParent, key, pointer, value);
    }

    if (targetParent === targetCollection) {
      const obj = this.newObject(targetParent, key, pointer);
      // it's actually in the right spot already.
      visitor.bind(this)(obj, children);
      return obj;
    }

    // not a reference, move the item

    const id =
      getNameHint(baseReferencePath, value, targetCollection, nameHint) ?? generateSchemaIdFromJsonPath(pointer);

    if (value["x-ms-client-name"] && baseReferencePath === "/components/schemas") {
      this.stats.namedSchemaInline++;
    }

    // set the current location's object to be a $ref
    targetParent[key] = {
      value: {
        ...includeXDashProperties(value),
        "$ref": `#${baseReferencePath}/${id}`,
        "description": value.description, // we violate spec to allow a unique description at the $ref spot, (ie: there are two fields that are of type 'color' -- one is 'borderColor' and one is 'fillColor' -- may be differen descriptions.)
        "x-ms-client-flatten": value["x-ms-client-flatten"], // we violate spec to allow flexibility in terms of flattening
        "x-ms-client-name": value["x-ms-client-name"], // we violate spec to allow flexibility in terms of naming too. *sigh*
        "readOnly": value.readOnly,
      },
      pointer,
    };

    // Q: I removed the 'targetCollection[key] ||' from this before. Why did I do that?
    // const tc = targetCollection[key] || this.newObject(targetCollection, id, pointer);
    const newRef = targetCollection[id] ?? this.newObject(targetCollection, id, pointer);

    // copy the parts of the parameter across
    visitor.bind(this)(newRef, children);

    if (baseReferencePath === "/components/schemas") {
      // x-ms-client-name correspond to the property, parameter, etc. name, not the model.
      delete newRef["x-ms-client-name"];
    }

    if (isAnonymous) {
      this.stats.anonymous++;
      newRef["x-internal-autorest-anonymous-schema"] = { value: { anonymous: true }, pointer: "" };
    }
    return newRef;
  }
}

async function shakeTree(context: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  const isSimpleTreeShake = !!context.GetEntry("simple-tree-shake");
  for (const each of inputs) {
    const shaker = new OAI3Shaker(each, isSimpleTreeShake);
    const output = await shaker.getOutput();

    context.stats.track({
      openapi: {
        specs: {
          [each.identity[0]]: {
            schemas: { ...shaker.stats },
          },
        },
      },
    });

    result.push(
      await sink.writeObject(
        "oai3.shaken.json",
        output,
        each.identity,
        "openapi-document-shaken",
        await shaker.getSourceMappings(),
      ),
    );
  }
  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createTreeShakerPlugin(): PipelinePlugin {
  return shakeTree;
}

function generateSchemaIdFromJsonPath(pointer: string): string {
  const value = hashedJsonPointer(pointer)
    .map((x) =>
      `${x}`
        .toLowerCase()
        .replace(/-+/g, "_")
        .replace(/\W+/g, "-")
        .split("-")
        .filter((each) => each)
        .join("-"),
    )
    .filter((each) => each)
    .join("·");
  return `${value}`.replace(/\·+/g, "·");
}

function getNameHint(
  baseReferencePath: string,
  value: any,
  targetCollection: AnyObject,
  nameHint?: string,
): string | undefined {
  if (nameHint) {
    // fix namehint to not have unexpected characters.
    const sanitizedName = nameHint.replace(/[\/\\]+/g, "-");
    if (targetCollection[sanitizedName]) {
      return undefined;
    }
    return sanitizedName;
  } else {
    if (baseReferencePath === "/components/schemas") {
      const initialName = value["x-ms-client-name"] ?? value.title;
      return findFirstAvailableKey(targetCollection, initialName);
    }
    return undefined;
  }
}

/**
 * Will return the first key that is not yet present in the `targetCollection` starting with the provided key.
 * It will first check if the provided key is availalble otherwise it will try {key}1, {key}2, etc.
 * @param targetCollection Object where the key will be inserted.
 * @param initialKey Initial value to check.
 */
function findFirstAvailableKey(targetCollection: AnyObject, initialKey: string): string {
  let current = initialKey;
  let i = 0;
  while (current && targetCollection[current]) {
    current = `${initialKey}${i++}`;
  }
  return current;
}
