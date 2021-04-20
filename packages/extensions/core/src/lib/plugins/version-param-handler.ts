import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  Transformer,
  ProxyObject,
  QuickDataSource,
  visit,
} from "@azure-tools/datastore";
import { clone, Dictionary } from "@azure-tools/linq";
import * as oai from "@azure-tools/openapi";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";

export class ApiVersionParameterHandler extends Transformer<any, oai.Model> {
  // oldRefs -> newRefs;
  apiVersionReferences = new Set<string>();

  public async init() {
    const allDocuments = await Promise.all([...this.inputs].map((each) => each.ReadObject<AnyObject>()));
    const currentDoc = allDocuments[0];

    if (currentDoc.components && currentDoc.components.parameters) {
      for (const { key, value } of visit(currentDoc.components.parameters)) {
        if (value.name && value.name === "api-version") {
          this.apiVersionReferences.add(`#/components/parameters/${key}`);
        }
      }
    }
  }

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "components":
          {
            const components =
              <oai.Components>targetParent.components || this.newObject(targetParent, "components", pointer);
            this.visitComponents(components, children);
          }
          break;

        case "paths":
          {
            const paths = <oai.PathItem>targetParent.paths || this.newObject(targetParent, "paths", pointer);
            this.visitPaths(paths, children);
          }
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "parameters":
          if (components[key] === undefined) {
            this.newObject(components, key, pointer);
          }
          this.visitComponent(key, components[key], children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(components, key, pointer, value);
          break;
      }
    }
  }

  visitPaths(paths: ProxyObject<Dictionary<oai.PathItem>>, nodes: Iterable<Node>) {
    for (const { value: pathValue, key: pathKey, pointer: pathPointer, children: pathMember } of nodes) {
      let hasApiVersion = false;
      const path = this.newObject(paths, pathKey, pathPointer);
      for (const { value, key, pointer, children } of pathMember) {
        switch (key) {
          case "get":
          case "put":
          case "post":
          case "delete":
          case "options":
          case "head":
          case "patch":
          case "trace":
            {
              const operation = this.newObject(path, key, pointer);

              for (const { value: v, key: k, pointer: p, children: c } of children) {
                switch (k) {
                  case "parameters":
                    {
                      const parameters: any = this.newArray(operation, k, p);
                      for (const { value: paramValue, pointer: paramPointer } of c) {
                        if (this.apiVersionReferences.has(paramValue.$ref) || paramValue.name === "api-version") {
                          hasApiVersion = true;
                        } else {
                          parameters.__push__({
                            value: paramValue,
                            pointer: paramPointer,
                            recurse: true,
                          });
                        }
                      }
                    }
                    break;
                  default:
                    this.copy(operation, k, p, v);
                    break;
                }
              }
            }
            break;
          case "parameters":
            {
              const externalOperation: any = this.newArray(path, key, pointer);
              for (const { value: paramValue, pointer: paramPointer } of children) {
                if (this.apiVersionReferences.has(paramValue.$ref) || paramValue.name === "api-version") {
                  hasApiVersion = true;
                } else {
                  externalOperation.__push__({
                    value: paramValue,
                    pointer: paramPointer,
                    recurse: true,
                  });
                }
              }
            }
            break;
          case "x-ms-metadata":
            // defer metadata processing until we know the final value of hasApiVersion.
            break;
          default:
            this.copy(path, key, pointer, value);
        }
      }

      const metadata = this.newObject(path, "x-ms-metadata", `${pathPointer}/x-ms-metadata`);
      for (const { value, key, pointer } of visit(pathValue["x-ms-metadata"])) {
        metadata[key] = { value, pointer };
      }

      if (hasApiVersion) {
        metadata["hasApiVersion"] = { value: true, pointer: pathPointer };
      }
    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      if (value.name !== "api-version") {
        this.clone(container, key, pointer, value);
      }
    }
  }
}

async function handleApiVersionParameter(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  if (config.GetEntry("azure-arm")) {
    for (const each of inputs) {
      const processor = new ApiVersionParameterHandler(each);
      const output = await processor.getOutput();
      result.push(
        await sink.WriteObject(
          "oai3.noapiversion.json",
          output,
          each.identity,
          "openapi-document-noapiversion",
          await processor.getSourceMappings(),
        ),
      );
    }
    return new QuickDataSource(result, input.pipeState);
  }
  return new QuickDataSource(inputs, input.pipeState);
}

/* @internal */
export function createApiVersionParameterHandlerPlugin(): PipelinePlugin {
  return handleApiVersionParameter;
}
