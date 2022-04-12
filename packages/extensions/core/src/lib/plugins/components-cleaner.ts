/*--------------------------------------------------------------------------------------------
 * Copyright(c) Microsoft Corporation.All rights reserved.
 * Licensed under the MIT License.See License.txt in the project root for license information.
 * --------------------------------------------------------------------------------------------*/

import { arrayify } from "@autorest/common";
import {
  AnyObject,
  DataHandle,
  DataSink,
  DataSource,
  Node,
  ProxyObject,
  QuickDataSource,
  Transformer,
} from "@azure-tools/datastore";
import * as oai from "@azure-tools/openapi";
import oai3 from "@azure-tools/openapi";
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

/**
 * Find unused components and remove them.
 */
export class ComponentsCleaner extends Transformer<any, oai.Model> {
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

  async init() {
    const doc = await this.inputs[0].ReadObject<oai3.Model>();
    const finder = new UnsuedComponentFinder(doc);
    this.componentsToKeep = finder.find();
  }

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "components":
          {
            const components = targetParent.components || this.newObject(targetParent, "components", pointer);
            this.visitComponents(components, children);
          }
          break;

        default:
          this.clone(targetParent, key as any, pointer, value);
          break;
      }
    }
  }

  private visitComponents(components: ProxyObject<Record<string, oai.Components>>, nodes: Iterable<Node>) {
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

/**
 * Logic to find the unsued components
 */
class UnsuedComponentFinder {
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

  private components: oai.Components;

  public constructor(private document: oai3.Model) {
    this.components = document.components ?? {};
  }

  /**
   * @returns components that are used.
   */
  public find(): ComponentTracker {
    this.findComponentsToKeepInPaths(this.document.paths);
    this.findComponentsToKeepInComponents();
    this.findComponentsToKeepFromPolymorphicRefs();

    return this.componentsToKeep;
  }

  private findComponentsToKeepInPaths(paths: AnyObject) {
    for (const value of Object.values(paths)) {
      this.crawlObject(value);
    }
  }

  private findComponentsToKeepInComponents() {
    for (const [containerType, container] of Object.entries(this.components)) {
      // Ignore extension properties(x-)
      if (!(containerType in this.visitedComponents)) {
        continue;
      }
      for (const [id, value] of Object.entries<any>(container)) {
        if (!value["x-ms-metadata"]["x-ms-secondary-file"]) {
          this.visitedComponents[containerType as keyof ComponentTracker].add(id);
          this.componentsToKeep[containerType as keyof ComponentTracker].add(id);
          this.crawlObject(value);
        }
      }
    }
  }

  private findComponentsToKeepFromPolymorphicRefs() {
    let entryAdded = false;
    do {
      entryAdded = false;

      for (const [containerType, containerComponents] of Object.entries(this.components)) {
        for (const [currentComponentUid, component] of Object.entries<any>(containerComponents)) {
          // only apply polymorphic pull-thru on objects with a polymorphic discriminator
          if (component?.["x-ms-discriminator-value"]) {
            if (this.checkRef(containerType as ComponentType, currentComponentUid, component, "allOf")) {
              entryAdded = true;
            }
            if (this.checkRef(containerType as ComponentType, currentComponentUid, component, "oneOf")) {
              entryAdded = true;
            }
            if (this.checkRef(containerType as ComponentType, currentComponentUid, component, "anyOf")) {
              entryAdded = true;
            }
            if (this.checkRef(containerType as ComponentType, currentComponentUid, component, "not")) {
              entryAdded = true;
            }
          }
        }
      }
    } while (entryAdded);
  }

  private checkRef(
    containerType: ComponentType,
    currentComponentUid: string,
    component: oai3.Schema,
    prop: "allOf" | "anyOf" | "oneOf" | "not",
  ) {
    const items = component[prop];
    if (items === undefined) {
      return;
    }

    for (const item of arrayify(items)) {
      if ("$ref" in item) {
        const refParts = item.$ref.split("/");
        const componentRefUid = refParts.pop();
        const refType = refParts.pop() as keyof ComponentTracker;
        if (
          this.componentsToKeep[refType].has(componentRefUid as string) &&
          !this.componentsToKeep[containerType].has(currentComponentUid)
        ) {
          this.componentsToKeep[containerType].add(currentComponentUid);
          this.crawlObject(component);
          return true;
        }
      }
    }
    return false;
  }

  private crawlObject(obj: any): void {
    for (const [key, value] of Object.entries(obj)) {
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
          const componentTypes = this.components[t];
          if (componentTypes === undefined) {
            throw new Error(`Reference '${value}' could not be found.`);
          }
          this.crawlObject(componentTypes[componentUid]);
        }
      } else if (value && typeof value === "object") {
        this.crawlObject(value);
      }
    }
  }
}

async function clean(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.enum()).map(async (x) => input.readStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new ComponentsCleaner(each);
    const output = await processor.getOutput();
    result.push(
      await sink.writeObject("oai3.cleaned.json", output, each.identity, "openapi-document-cleaned", {
        pathMappings: await processor.getSourceMappings(),
      }),
    );
  }

  return new QuickDataSource(result, input.pipeState);
}

/* @internal */
export function createComponentsCleanerPlugin(): PipelinePlugin {
  return clean;
}
