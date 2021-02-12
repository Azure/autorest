/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { visit } from "@azure-tools/datastore";
import { Dictionary, items, clone } from "@azure-tools/linq";
import { areSimilar } from "@azure-tools/object-comparison";
import compareVersions from "compare-versions";
import { toSemver, maximum } from "@azure-tools/codegen";
import { YieldCPU } from "@azure-tools/tasks";

type componentType =
  | "schemas"
  | "responses"
  | "parameters"
  | "examples"
  | "requestBodies"
  | "headers"
  | "securitySchemes"
  | "links"
  | "callbacks";

function getMergedProfilesMetadata(
  dict1: Dictionary<string>,
  dict2: Dictionary<string>,
  path: string,
  originalLocations: Array<string>,
): { [key: string]: string } {
  const result: { [key: string]: string } = {};
  for (const { value, key } of items(dict1)) {
    result[key] = value;
  }

  for (const item of items(dict2)) {
    if (result[item.key] !== undefined && result[item.key] !== item.value) {
      throw Error(
        `Deduplicator: There's a conflict trying to deduplicate these two path objects with path ${path}, and with original locations ${originalLocations}. Both come from the same profile ${
          item.key
        }, but they have different api-versions: ${result[item.key]} and ${item.value}`,
      );
    }

    result[item.key] = item.value;
  }

  return result;
}

export class Deduplicator {
  private hasRun = false;

  // table:
  // prevPointers -> newPointers
  // this will serve to generate a source map externally
  private mappings = new Dictionary<string>();

  // table:
  // oldRefs -> newRefs
  private refs = new Dictionary<string>();

  // sets containing the UIDs of already deduplicated components
  private deduplicatedComponents = {
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

  // sets containing the UIDs of components already crawled
  private crawledComponents = {
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

  // sets containing the UIDs of components already visited.
  // This is used to prevent circular references.
  private visitedComponents = {
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

  // initially the target is the same as the original object
  private target: any;
  constructor(originalFile: any, protected deduplicateInlineModels = false) {
    this.target = clone(originalFile);
    this.target.info["x-ms-metadata"].deduplicated = true;
  }

  private async init() {
    // set initial refs table
    // NOTE: The deduplicator assumes that the document is merged-document from multiple tree-shaken files,
    //        and for that reason the only references in the document are local component references.
    for (const { key: type, children } of visit(this.target.components)) {
      for (const { key: uid } of children) {
        this.refs[`#/components/${type}/${uid}`] = `#/components/${type}/${uid}`;
      }
    }

    // 1. deduplicate components
    if (this.target.components) {
      await this.deduplicateComponents();
    }

    // 2. deduplicate remaining fields
    for (const { key: fieldName } of visit(this.target)) {
      if (fieldName === "paths") {
        if (this.target.paths) {
          this.deduplicatePaths();
        }
      } else if (fieldName !== "components" && fieldName !== "openapi") {
        if (this.target[fieldName]) {
          this.deduplicateAdditionalFieldMembers(fieldName);
        }
      }
    }
  }

  private deduplicateAdditionalFieldMembers(fieldName: string) {
    const deduplicatedMembers = new Set<string>();
    const element = this.target[fieldName];

    // If it is a string there is nothing to deduplicate.
    if (typeof element === "string") {
      return;
    }

    // TODO: remaining fields are arrays and not maps, so when a member is deleted
    // it leaves an empty item. Figure out what is the best way to handle this.
    // convert to map and then delete?
    for (const { key: memberUid } of visit(element)) {
      if (!deduplicatedMembers.has(memberUid)) {
        const member = element[memberUid];

        // iterate over all the members
        for (const { key: anotherMemberUid, value: anotherMember } of visit(element)) {
          // ignore merge with itself
          if (memberUid !== anotherMemberUid && areSimilar(member, anotherMember)) {
            // finish up
            delete element[anotherMemberUid];
            this.updateMappings(`/${fieldName}/${anotherMemberUid}`, `/${fieldName}/${memberUid}`);
            deduplicatedMembers.add(anotherMemberUid);
          }
        }

        deduplicatedMembers.add(memberUid);
      }
    }

    let counter = 0;
    // clean up empty items if it was an array and update mappings
    if (Array.isArray(this.target[fieldName])) {
      this.target[fieldName] = this.target[fieldName].filter((element: any, index: number) => {
        if (element) {
          this.updateMappings(`/${fieldName}/${index}`, `/${fieldName}/${counter}`);
          counter++;
          return element;
        }
      });
    }
  }

  private deduplicatePaths() {
    const deduplicatedPaths = new Set<string>();
    for (let { key: pathUid } of visit(this.target.paths)) {
      if (!deduplicatedPaths.has(pathUid)) {
        const xMsMetadata = "x-ms-metadata";
        const path = this.target.paths[pathUid];

        // extract metadata to be merged
        let apiVersions = path[xMsMetadata].apiVersions;
        let filename = path[xMsMetadata].filename;
        let originalLocations = path[xMsMetadata].originalLocations;
        const pathFromMetadata = path[xMsMetadata].path;
        let profiles = path[xMsMetadata].profiles;

        // extract path properties excluding metadata
        const { "x-ms-metadata": metadataCurrent, ...filteredPath } = path;

        // iterate over all the paths
        for (const { key: anotherPathUid, value: anotherPath } of visit(this.target.paths)) {
          // ignore merge with itself && anotherPath already deleted (i.e. undefined)
          if (anotherPath !== undefined && pathUid !== anotherPathUid) {
            // extract the another path's properties excluding metadata
            const { "x-ms-metadata": metadataSchema, ...filteredAnotherPath } = anotherPath;

            // TODO: Add more keys to ignore.
            const keysToIgnore: Array<string> = ["description", "tags", "x-ms-original", "x-ms-examples"];

            // they should have the same name to be merged and they should be similar
            if (
              path[xMsMetadata].path === anotherPath[xMsMetadata].path &&
              areSimilar(filteredPath, filteredAnotherPath, ...keysToIgnore)
            ) {
              // merge metadata
              apiVersions = apiVersions.concat(anotherPath[xMsMetadata].apiVersions);
              filename = filename.concat(anotherPath[xMsMetadata].filename);
              originalLocations = originalLocations.concat(anotherPath[xMsMetadata].originalLocations);
              profiles = getMergedProfilesMetadata(
                profiles,
                anotherPath[xMsMetadata].profiles,
                path[xMsMetadata].path,
                originalLocations,
              );

              // the discriminator to take contents is the api version
              const maxApiVersionPath = maximum(path[xMsMetadata].apiVersions);
              const maxApiVersionAnotherPath = maximum(anotherPath[xMsMetadata].apiVersions);
              let uidPathToDelete = anotherPathUid;
              if (compareVersions(toSemver(maxApiVersionPath), toSemver(maxApiVersionAnotherPath)) === -1) {
                // if the current path max api version is less than the another path, swap ids.
                uidPathToDelete = pathUid;
                pathUid = anotherPathUid;
              }

              // finish up
              delete this.target.paths[uidPathToDelete];
              this.updateMappings(`/paths/${uidPathToDelete}`, `/paths/${pathUid}`);
              deduplicatedPaths.add(uidPathToDelete);
            }
          }
        }

        this.target.paths[pathUid][xMsMetadata] = {
          apiVersions: [...new Set([...apiVersions])],
          filename: [...new Set([...filename])],
          path: pathFromMetadata,
          profiles,
          originalLocations: [...new Set([...originalLocations])],
        };
        deduplicatedPaths.add(pathUid);
      }
    }
  }

  private async deduplicateComponents() {
    for (const { key: type, children: componentsMember } of visit(this.target.components)) {
      for (const { key: componentUid } of componentsMember) {
        await YieldCPU();
        await this.deduplicateComponent(componentUid, type);
      }
    }
  }

  private async deduplicateComponent(componentUid: string, type: string) {
    switch (type) {
      case "schemas":
      case "responses":
      case "parameters":
      case "examples":
      case "requestBodies":
      case "headers":
      case "links":
      case "callbacks":
      case "securitySchemes":
        if (!this.deduplicatedComponents[type].has(componentUid)) {
          if (!this.crawledComponents[type].has(componentUid)) {
            await YieldCPU();
            await this.crawlComponent(componentUid, type);
          }

          // Just try to deduplicate if it was not deduplicated while crawling another component.
          if (!this.deduplicatedComponents[type].has(componentUid)) {
            // deduplicate crawled component
            const xMsMetadata = "x-ms-metadata";
            const component = this.target.components[type][componentUid];

            // extract metadata to be merged
            let apiVersions = component[xMsMetadata].apiVersions;
            let filename = component[xMsMetadata].filename;
            let originalLocations = component[xMsMetadata].originalLocations;
            let name = component[xMsMetadata].name;

            // extract component properties excluding metadata
            const { "x-ms-metadata": metadataCurrent, ...filteredComponent } = component;

            // iterate over all the components of the same type of the component
            for (const { key: anotherComponentUid, value: anotherComponent } of visit(this.target.components[type])) {
              // ignore merge with itself && anotherComponent already deleted (i.e. undefined)
              if (anotherComponent !== undefined && componentUid !== anotherComponentUid) {
                // extract the another component's properties excluding metadata
                const { "x-ms-metadata": metadataSchema, ...filteredAnotherComponent } = anotherComponent;

                // TODO: Add more keys to ignore.
                const keysToIgnore: Array<string> = ["description", "x-ms-original", "x-ms-examples"];

                const namesMatch = this.deduplicateInlineModels
                  ? anotherComponent[xMsMetadata].name.replace(/\d*$/, "") ===
                      component[xMsMetadata].name.replace(/\d*$/, "") ||
                    (anotherComponent[xMsMetadata].name.indexOf("·") > -1 &&
                      component[xMsMetadata].name.indexOf("·") > -1)
                  : anotherComponent[xMsMetadata].name.replace(/\d*$/, "") ===
                    component[xMsMetadata].name.replace(/\d*$/, "");

                // const t1 = component['type'];
                // const t2 = anotherComponent['type'];
                // const typesAreSame = t1 === t2;
                // const isObjectSchema = t1 === 'object' || t1 === undefined;
                // const isStringSchemaWithFormat = !!(t1 === 'string' && component['format']);

                // (type === 'schemas' && t1 === t2 && (t1 === 'object' || (t1 === 'string' && component['format']) || t1 === undefined))
                // they should have the same name to be merged and they should be similar
                if (
                  namesMatch &&
                  // typesAreSame &&
                  // (isObjectSchema || isStringSchemaWithFormat) &&
                  areSimilar(filteredAnotherComponent, filteredComponent, ...keysToIgnore)
                ) {
                  // if the primary has a synthetic name, and the secondary doesn't use the secondary's name
                  if (name.indexOf("·") > 0 && anotherComponent[xMsMetadata].name.indexOf("·") === -1) {
                    name = anotherComponent[xMsMetadata].name;
                  }

                  // merge metadata
                  apiVersions = apiVersions.concat(anotherComponent[xMsMetadata].apiVersions);
                  filename = filename.concat(anotherComponent[xMsMetadata].filename);
                  originalLocations = originalLocations.concat(anotherComponent[xMsMetadata].originalLocations);

                  // the discriminator to take contents is the api version
                  const maxApiVersionComponent = maximum(component[xMsMetadata].apiVersions);
                  const maxApiVersionAnotherComponent = maximum(anotherComponent[xMsMetadata].apiVersions);
                  let uidComponentToDelete = anotherComponentUid;
                  if (
                    compareVersions(toSemver(maxApiVersionComponent), toSemver(maxApiVersionAnotherComponent)) === -1
                  ) {
                    // if the current component max api version is less than the another component, swap ids.
                    uidComponentToDelete = componentUid;
                    componentUid = anotherComponentUid;
                  }

                  // finish up
                  delete this.target.components[type][uidComponentToDelete];
                  this.refs[`#/components/${type}/${uidComponentToDelete}`] = `#/components/${type}/${componentUid}`;
                  this.updateRefs(this.target);
                  this.updateMappings(
                    `/components/${type}/${uidComponentToDelete}`,
                    `/components/${type}/${componentUid}`,
                  );
                  this.deduplicatedComponents[type].add(uidComponentToDelete);
                }
              }
            }

            this.target.components[type][componentUid][xMsMetadata] = {
              apiVersions: [...new Set([...apiVersions])],
              filename: [...new Set([...filename])],
              name,
              originalLocations: [...new Set([...originalLocations])],
            };

            this.deduplicatedComponents[type].add(componentUid);
          }
        }
        break;
      default:
        throw new Error(`Unknown component type: '${type}'`);
    }
  }

  private async crawlComponent(uid: string, type: componentType) {
    if (!this.visitedComponents[type].has(uid)) {
      if (this.target.components[type][uid]) {
        this.visitedComponents[type].add(uid);
        await this.crawlObject(this.target.components[type][uid]);
      } else {
        throw new Error(`Trying to crawl undefined component with uid '${uid}' and type '${type}'!`);
      }
    }

    this.crawledComponents[type].add(uid);
  }

  private async crawlObject(obj: any) {
    for (const { key, value } of visit(obj)) {
      // We don't want to navigate the examples.
      if (key === "x-ms-examples") {
        continue;
      }

      if (key === "$ref") {
        const refParts = value.split("/");
        const componentUid = refParts.pop();
        const type = refParts.pop();
        await this.deduplicateComponent(componentUid, type);
      } else if (value && typeof value === "object") {
        await this.crawlObject(value);
      }
    }
  }

  private updateRefs(obj: any): void {
    for (const { key, value } of visit(obj)) {
      // We don't want to navigate the examples.
      if (key === "x-ms-examples") {
        continue;
      }

      if (value && typeof value === "object") {
        const ref = value.$ref;
        if (ref) {
          // see if this object has a $ref
          const newRef = this.refs[ref];
          if (newRef) {
            value.$ref = newRef;
          } else {
            throw new Error(`$ref to original location '${ref}' is not found in the new refs collection`);
          }
        }

        // now, recurse into this object
        this.updateRefs(value);
      }
    }
  }

  private updateMappings(oldPointer: string, newPointer: string): void {
    this.mappings[oldPointer] = newPointer;
    for (const [key, value] of Object.entries(this.mappings)) {
      if (value === oldPointer) {
        this.mappings[key] = newPointer;
      }
    }
  }

  public async getOutput() {
    if (!this.hasRun) {
      await this.init();
      this.hasRun = true;
    }
    return this.target;
  }

  public async getSourceMappings() {
    if (!this.hasRun) {
      await this.init();
      this.hasRun = true;
    }
    return this.mappings;
  }
}
