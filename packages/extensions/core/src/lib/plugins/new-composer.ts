import {
  AnyObject,
  DataSink,
  DataSource,
  Transformer,
  Node,
  ProxyObject,
  QuickDataSource,
  visit,
} from "@azure-tools/datastore";
import { values, Dictionary } from "@azure-tools/linq";
import { areSimilar } from "@azure-tools/object-comparison";
import { PipelinePlugin } from "../pipeline/common";
import { maximum, toSemver } from "@azure-tools/codegen";
import compareVersions from "compare-versions";
import { AutorestContext } from "../context";

/**
 * Prepares an OpenAPI document for the generation-2 code generators
 * (ie, anything before MultiAPI was introduced)
 *
 * This takes the Merged OpenAPI document and tweaks it so that it will work with earlier
 * Code Model-v1 generators.
 *
 * This replaces the original 'composer'
 *
 * Notably:
 *  inlines schema $refs for operation parameters because the existing modeler doesn't unwrap $ref'd schemas for parameters
 *  Inlines header $refs for responses
 *  inline produces/consumes
 *  Ensures there is but one title
 *  inlines API version as a constant parameter
 *
 */

export class NewComposer extends Transformer<AnyObject, AnyObject> {
  private uniqueVersion!: boolean;

  // there could be more than one global parameter called api-version
  private apiVersionParamReferences = new Set<string>();
  refs = new Dictionary<string>();

  get components(): AnyObject {
    if (this.generated.components) {
      return this.generated.components;
    }
    if (this.current.components) {
      return this.newObject(this.generated, "components", "/components");
    }
    return this.newObject(this.generated, "components", "/");
  }

  get paths(): AnyObject {
    if (this.generated.paths) {
      return this.generated.paths;
    }
    if (this.current.paths) {
      return this.newObject(this.generated, "paths", "/paths");
    }
    return this.newObject(this.generated, "paths", "/");
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

  public async process(target: ProxyObject<AnyObject>, nodes: Iterable<Node>) {
    const metadata = this.current.info ? this.current.info["x-ms-metadata"] : {};
    this.uniqueVersion = metadata.apiVersions.length > 1 ? false : true;
    if (this.current.components) {
      for (const { value, key } of visit(this.current.components.parameters)) {
        if (value.name === "api-version") {
          this.apiVersionParamReferences.add(`#/components/parameters/${key}`);
        }
      }
    }

    for (const { key, value, pointer, children } of nodes) {
      switch (key) {
        case "paths":
          this.visitPaths(this.paths, children);
          break;

        case "components":
          this.visitComponents(this.components, children);
          break;

        case "info":
        case "servers":
        case "openapi":
          this.clone(target, key, pointer, value);
          break;

        default:
          if (Array.isArray(value)) {
            this.cloneInto(<AnyObject>this.getOrCreateArray(target, key, pointer), children);
          } else {
            this.cloneInto(<AnyObject>this.getOrCreateObject(target, key, pointer), children);
          }

          break;
      }
    }
  }

  public async finish() {
    this.updateRefs(this.generated);
  }

  protected updateRefs(node: any) {
    for (const { value } of visit(node)) {
      if (value && typeof value === "object") {
        const ref = value.$ref;
        if (ref) {
          // see if this object has a $ref
          const newRef = this.refs[ref];
          if (newRef) {
            value.$ref = newRef;
          } else {
            // throw new Error(`$ref to original location '${ref}' is not found in the new refs collection`);
          }
        }
        // now, recurse into this object
        this.updateRefs(value);
      }
    }
  }
  protected visitPaths(target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      const actualPath = value["x-ms-metadata"] && value["x-ms-metadata"].path ? value["x-ms-metadata"].path : key;
      if (target[actualPath] === undefined) {
        // new object
        this.visitPath(value["x-ms-metadata"], this.newObject(target, actualPath, pointer), children);
      } else {
        // we split up the operations when we merged in order to enable the deduplicator to work it's
        // magic on the operations
        // but the older modeler needs them mereged together again
        // luckily, it won't have any $refs to the paths, so I'm not worried about fixing those up.
        this.visitPath(value["x-ms-metadata"], target[actualPath], children);
        // if (!areSimilar(value, target[actualPath], 'x-ms-metadata', 'description', 'summary')) {
        //throw new Error(`Incompatible paths conflicting: ${pointer}: ${actualPath}`);
        //}
      }
    }
  }

  protected visitPath(metadata: AnyObject, target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, pointer, children } of nodes) {
      if (target[key] && !key.startsWith("x-ms")) {
        // we're attempting to put another operation at the same path/method
        // where there is one already.
        // This is likely a case where a multi-api-version file is trying to
        // go thru the composer, and this is not allowed.
        throw new Error(
          `There are multiple operations defined for \n  '${key}: ${metadata.path}'.\n\n  You are probably trying to use an input with multiple API versions with an autorest V2 generator, and that will not work. `,
        );
      }
      this.visitOperation(metadata, this.getOrCreateObject(target, key, pointer), children);
    }
  }

  protected visitOperation(metadata: AnyObject, target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      // we have to pull thru $refs on properties' *schema* and
      switch (key) {
        case "parameters":
          this.visitAndDereferenceArray(metadata, target, key, pointer, children);
          break;

        case "responses":
          this.visitResponses(this.newObject(target, key, pointer), children);
          break;

        default:
          // @future_garrett -- this is done to allow paths to be re-integrated
          // after deduplication. If this gives you problems, don't say I didn't
          // warn you.
          if (!target[key]) {
            this.clone(target, key, pointer, value);
          }
          break;
      }
    }
  }

  protected lookupRef(reference: string): AnyObject {
    // since we know that the references are all in this file
    // we should be able to find the referenced item.
    const [, path] = reference.split("#/");
    const [components, component, location] = path.split("/");
    return this.current[components][component][location];
  }

  protected visitAndDereferenceArray(
    metadata: AnyObject,
    target: AnyObject,
    k: string,
    ptr: string,
    nodes: Iterable<Node>,
  ) {
    const parametersArray = this.newArray(target, k, ptr);
    for (const { value, pointer } of nodes) {
      if (this.apiVersionParamReferences.has(value.$ref)) {
        const p = {
          name: "api-version",
          in: "query",
          description: "The API version to use for the request.",
          required: true,
          schema: {
            type: "string",
            enum: [metadata["apiVersions"][0]],
          },
        };

        parametersArray.__push__({ value: p, pointer: ptr, recurse: true, filename: this.currentInputFilename });
        continue;
      }

      parametersArray.__push__({
        value: JSON.parse(JSON.stringify(value)),
        pointer,
        recurse: true,
        filename: this.currentInputFilename,
      });
    }
  }

  protected visitAndDerefObject(target: AnyObject, nodes: Iterable<Node>) {
    // for each parameter, we have to pull thru the $ref'd parameter
    for (const { key, value, pointer } of nodes) {
      if (value.$ref) {
        // look up the ref and clone it.
        this.clone(target, key, pointer, this.lookupRef(value.$ref));
      } else {
        this.clone(target, key, pointer, value);
      }
    }
  }

  protected cloneInto<TParent extends object>(target: ProxyObject<TParent>, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      if (target[key as keyof TParent] === undefined) {
        // the value isn't in the target. We can take it from the source
        this.clone(<AnyObject>target, key, pointer, value);
      } else {
        if (!areSimilar(value, target[key as keyof TParent], "x-ms-metadata", "description", "summary")) {
          throw new Error(`Incompatible models conflicting: ${pointer}`);
        }
      }
    }
    return target;
  }

  protected visitResponses(responses: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, pointer, children } of originalNodes) {
      this.visitResponse(this.newObject(responses, key, pointer), children);
    }
  }

  protected visitResponse(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      switch (key) {
        case "headers":
          // headers that are  $ref'd and we need to inline it
          // because the imodeler1 doesn't know how to deal with that.
          this.inlineHeaders(this.newObject(target, key, pointer), children);
          break;

        default:
          this.clone(target, key, pointer, value);
          break;
      }
    }
  }

  protected inlineHeaders(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      // if the header is a $ref then we have to inline it.
      if (value.$ref) {
        const actualHeader = this.lookupRef(value.$ref);

        if (actualHeader.schema && actualHeader.schema.$ref) {
          // this has a schema that has to be derefed too.
          // this.clone(target, key, pointer, actualHeader);
          this.inlineHeaderCorrectly(this.newObject(target, key, pointer), visit(actualHeader));
        } else {
          // it's specified as a reference
          this.clone(target, key, pointer, actualHeader);
        }
      } else {
        this.clone(target, key, pointer, value);
      }
    }
  }

  protected inlineHeaderCorrectly(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      if (value.$ref) {
        // it's specified as a reference
        this.clone(target, key, pointer, this.lookupRef(value.$ref));
      } else {
        this.clone(target, key, pointer, value);
      }
    }
  }

  protected inlineHeader(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      if (value.$ref) {
        // it's specified as a reference
        this.visitAndDerefObject(this.newObject(target, key, pointer), children);
      } else {
        this.clone(target, key, pointer, value);
      }
    }
  }
  protected inlineHeaderSchema(header: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      switch (key) {
        case "schema":
          if (value.$ref) {
            // header schemas have to be inlined because the imodeler1 can't handle them
            this.clone(header, key, pointer, this.lookupRef(value.$ref));
          } else {
            this.clone(header, key, pointer, value);
          }
          break;

        default:
          this.clone(header, key, pointer, value);
          break;
      }
    }
  }

  protected visitSchemas(target: AnyObject, originalNodes: Iterable<Node>) {
    // since some models are going to be duplicated and this composer is used to mimic autorest v2
    // the best behavior is to have the latest models.
    const sortedNodes = values(originalNodes)
      .toArray()
      .sort((a, b) =>
        compareVersions(
          toSemver(maximum(b.value["x-ms-metadata"].apiVersions)),
          toSemver(maximum(a.value["x-ms-metadata"].apiVersions)),
        ),
      );
    for (const { key, value, pointer } of sortedNodes) {
      // schemas have to keep their name
      const schemaName = !value["type"] || value["type"] === "object" ? value["x-ms-metadata"].name : key;

      // this is pulling up the name of the schema back from the x-ms-metadata.
      // we do this because we don't want to alter the modeler
      // this is being added to the merger, since it looks like we want this behavior there too.
      if (target[schemaName] === undefined) {
        // the value isn't in the target. We can take it from the source'
        target[schemaName] = { value, pointer };
      }

      this.refs[`#/components/schemas/${key}`] = `#/components/schemas/${schemaName}`;
    }
    return target;
  }

  protected visitParameter(parameter: ProxyObject<AnyObject>, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      switch (key) {
        case "schema":
          if (value.$ref) {
            // parameter schemas have to be inlined because the imodeler1 can't handle them
            this.clone(parameter, key, pointer, this.lookupRef(value.$ref));
          } else {
            this.clone(parameter, key, pointer, value);
          }
          break;

        default:
          this.clone(parameter, key, pointer, value);
          break;
      }
    }
  }

  protected visitParameters(target: ProxyObject<AnyObject>, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      if (!this.uniqueVersion && value.name === "api-version") {
        // strip out the api version parameter when we inlined them.
        continue;
      }

      this.visitParameter(this.newObject(target, key, pointer), children);
    }
    return target;
  }

  visitComponents(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "schemas":
          this.visitSchemas(this.schemas, children);
          break;

        case "responses":
          this.visitResponses(this.responses, children);
          break;

        case "parameters":
          this.visitParameters(this.parameters, children);
          break;

        case "examples":
          this.cloneInto(this.examples, children);
          break;

        case "requestBodies":
          this.cloneInto(this.requestBodies, children);
          break;

        case "headers":
          this.cloneInto(this.headers, children);
          break;

        case "securitySchemes":
          this.cloneInto(this.securitySchemes, children);
          break;

        case "links":
          this.cloneInto(this.links, children);
          break;

        case "callbacks":
          this.cloneInto(this.callbacks, children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }
}

async function compose(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));

  // compose-a-vous!
  const composer = new NewComposer(inputs[0]);
  return new QuickDataSource(
    [
      await sink.WriteObject(
        "composed oai3 doc...",
        await composer.getOutput(),
        // eslint-disable-next-line prefer-spread
        [].concat.apply([], <any>inputs.map((each) => each.identity)),
        "merged-oai3",
        await composer.getSourceMappings(),
      ),
    ],
    input.pipeState,
  );
}

/* @internal */
export function createNewComposerPlugin(): PipelinePlugin {
  return compose;
}
