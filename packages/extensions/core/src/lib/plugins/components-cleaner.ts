/*--------------------------------------------------------------------------------------------
 * Copyright(c) Microsoft Corporation.All rights reserved.
 * Licensed under the MIT License.See License.txt in the project root for license information.
 * --------------------------------------------------------------------------------------------*/

import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  ProxyObject,
  QuickDataSource,
  Transformer,
  visit,
} from "@azure-tools/datastore";
import { Dictionary } from "@azure-tools/linq";
import * as oai from "@azure-tools/openapi";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";

/**
 * components-to-keep are the ones that:
 *
 * 1 Come from a primary-file.
 * 2 Come from a secondary-file and are referenced by a primary-file component.
 * 3 Come from a secondary-file and are referenced by something in a primary file (e.g paths, security, etc).
 *
 */

type ComponentType =
  | "schemas"
  | "responses"
  | "parameters"
  | "examples"
  | "requestBodies"
  | "headers"
  | "securitySchemes"
  | "links"
  | "callbacks";

interface ComponentTracker {
  schemas: Set<string>;
  responses: Set<string>;
  parameters: Set<string>;
  examples: Set<string>;
  requestBodies: Set<string>;
  headers: Set<string>;
  securitySchemes: Set<string>;
  links: Set<string>;
  callbacks: Set<string>;
}

export class ComponentsCleaner extends Transformer<any, oai.Model> {
  private visitedComponents: ComponentTracker = {
    schemas: new Set<string>(),
    responses: new Set<string>(),
    parameters: new Set<string>(),
    examples: new Set<string>(),
    requestBodies: new Set<string>(),
    headers: new Set<string>(),
    securitySchemes: new Set<string>(),
    links: new Set<string>(),
    callbacks: new Set<string>(),
  };

  private componentsToKeep: ComponentTracker = {
    schemas: new Set<string>(),
    responses: new Set<string>(),
    parameters: new Set<string>(),
    examples: new Set<string>(),
    requestBodies: new Set<string>(),
    headers: new Set<string>(),
    securitySchemes: new Set<string>(),
    links: new Set<string>(),
    callbacks: new Set<string>(),
  };

  private components: AnyObject = {};

  async init() {
    const doc = await this.inputs[0].ReadObject<AnyObject>();
    this.components = doc.components;
    this.findComponentsToKeepInPaths(doc.paths);
    this.findComponentsToKeepInComponents();
    this.findComponentsToKeepFromPolymorphicRefs();
  }

  findComponentsToKeepInPaths(paths: AnyObject) {
    for (const { value, key } of visit(paths)) {
      this.crawlObject(value);
    }
  }

  findComponentsToKeepInComponents() {
    for (const { children, key: containerType } of visit(this.components)) {
      // Ignore extension properties(x-)
      if (!(containerType in this.visitedComponents)) {
        continue;
      }
      for (const { value, key: id } of children) {
        if (!value["x-ms-metadata"]["x-ms-secondary-file"]) {
          this.visitedComponents[containerType as keyof ComponentTracker].add(id);
          this.componentsToKeep[containerType as keyof ComponentTracker].add(id);
          this.crawlObject(value);
        }
      }
    }
  }

  findComponentsToKeepFromPolymorphicRefs() {
    let entryAdded = false;
    do {
      entryAdded = false;

      for (const { children: containerChildren, key: containerType } of visit(this.components)) {
        for (const { value: component, key: currentComponentUid, children: componentChildren } of containerChildren) {
          // only apply polymorphic pull-thru on objects with a polymorphic discriminator
          if (component?.["x-ms-discriminator-value"]) {
            for (const { value: componentField, key: componentFieldName } of componentChildren) {
              switch (componentFieldName) {
                case "allOf":
                case "oneOf":
                case "anyOf":
                  for (const { value: obj } of visit(componentField)) {
                    if (obj.$ref) {
                      const refParts = obj.$ref.split("/");
                      const componentRefUid = refParts.pop();
                      const refType = refParts.pop();
                      if (
                        this.componentsToKeep[refType as keyof ComponentTracker].has(componentRefUid) &&
                        !this.componentsToKeep[containerType as keyof ComponentTracker].has(currentComponentUid)
                      ) {
                        this.componentsToKeep[containerType as keyof ComponentTracker].add(currentComponentUid);
                        this.crawlObject(component);
                        entryAdded = true;
                      }
                    }
                  }
                  break;
                case "not":
                  if (componentField.$ref) {
                    const refParts = componentField.$ref.split("/");
                    const componentRefUid = refParts.pop();
                    const refType = refParts.pop();
                    if (
                      this.componentsToKeep[refType as keyof ComponentTracker].has(componentRefUid) &&
                      !this.componentsToKeep[containerType as keyof ComponentTracker].has(currentComponentUid)
                    ) {
                      this.componentsToKeep[containerType as keyof ComponentTracker].add(currentComponentUid);
                      this.crawlObject(component);
                      entryAdded = true;
                    }
                  }
                  break;
                default:
                  break;
              }
            }
          }
        }
      }
    } while (entryAdded);
  }

  private crawlObject(obj: any): void {
    for (const { key, value } of visit(obj)) {
      // We don't want to navigate the examples.
      if (key === "x-ms-examples") {
        continue;
      }
      if (key === "$ref" && typeof value === "string") {
        const refParts = value.split("/");
        const componentUid = refParts.pop() as string;
        const t: ComponentType = refParts.pop() as ComponentType;
        if (!this.visitedComponents[t].has(componentUid)) {
          this.visitedComponents[t].add(componentUid);
          this.componentsToKeep[t].add(componentUid);
          this.crawlObject(this.components[t][componentUid]);
        }
      } else if (value && typeof value === "object") {
        this.crawlObject(value);
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

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {
    for (const {
      key: containerType,
      pointer: containerPointer,
      children: containerChildren,
      value: containerValue,
    } of nodes) {
      switch (containerType) {
        case "responses":
        case "schemas":
        case "parameters":
        case "requestBodies":
        case "headers":
          this.newObject(components, containerType, containerPointer);
          for (const { key: componentId, pointer: componentPointer, value: componentValue } of containerChildren) {
            if (this.componentsToKeep[containerType].has(componentId)) {
              this.clone(<AnyObject>components[containerType], componentId, componentPointer, componentValue);
            }
          }
          break;
        default:
          if (components[containerType] === undefined) {
            this.clone(components, containerType, containerPointer, containerValue);
          }

          break;
      }
    }
  }
}

async function clean(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new ComponentsCleaner(each);
    const output = await processor.getOutput();
    result.push(
      await sink.WriteObject(
        "oai3.cleaned.json",
        output,
        each.identity,
        "openapi-document-cleaned",
        await processor.getSourceMappings(),
      ),
    );
  }

  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createComponentsCleanerPlugin(): PipelinePlugin {
  return clean;
}
