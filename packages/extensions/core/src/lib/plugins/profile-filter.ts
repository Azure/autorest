/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
/* eslint-disable @typescript-eslint/no-use-before-define */
/* eslint-disable no-useless-escape */

import { maximum, serialize } from "@azure-tools/codegen";
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
  ConvertJsonx2Yaml,
} from "@azure-tools/datastore";
import { Dictionary, items, values } from "@azure-tools/linq";
import * as oai from "@azure-tools/openapi";
import { AutorestContext } from "../context";
import { PipelinePlugin } from "../pipeline/common";

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

interface PathMetadata {
  apiVersions: Array<string>;
  filename: Array<string>;
  path: string;
  profiles: Dictionary<string>;
  originalLocations: Array<string>;
}

interface ResourceData {
  apiVersion: string;
  profile: string;
  matches: Array<string>;
}

interface OperationData {
  apiVersion: string;
  profile: string;
  path: string;
}

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

export class ProfileFilter extends Transformer<any, oai.Model> {
  filterTargets: Array<{ apiVersion: string; profile: string; pathRegex: RegExp; weight: number }> = [];

  // sets containing the UIDs of components already visited.
  // This is used to prevent circular references.
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

  // This holds allOf, anyOf, oneOf, not references
  private polymorphicReferences = new Dictionary<Set<string>>();

  private components: any;
  private profilesApiVersions: Array<string> = [];
  private apiVersions: Array<string> = [];
  private maxApiVersion = "";
  private profilesReferenced = new Set<string>();

  constructor(
    input: DataHandle,
    private profiles: any,
    private profilesToUse: Array<string>,
    apiVersions: Array<string>,
  ) {
    super(input);
    this.apiVersions = apiVersions;
  }

  async init() {
    const currentDoc = await this.inputs[0].ReadObject<AnyObject>();
    this.components = currentDoc["components"];
    if (this.profilesToUse.length > 0) {
      const resourcesTargets: Array<ResourceData> = [];
      const operationTargets: Array<OperationData> = [];
      for (const { key: profileName, value: profile } of visit(this.profiles)) {
        if (this.profilesToUse.includes(profileName)) {
          // get resources targets
          for (const { key: namespace, value: namespaceValue } of visit(profile.resources)) {
            for (const { key: version, value: resourceTypes } of visit(namespaceValue)) {
              if (resourceTypes.length === 0) {
                resourcesTargets.push({ apiVersion: version, profile: profileName, matches: [namespace] });
              } else {
                for (const resourceType of resourceTypes) {
                  resourcesTargets.push({
                    apiVersion: version,
                    profile: profileName,
                    matches: [namespace, ...resourceType.split("/")],
                  });
                }
              }
            }
          }

          // get operations targets
          for (const { key: path, value: apiVersion } of visit(profile.operations)) {
            operationTargets.push({ apiVersion, profile: profileName, path });
          }
        }
      }

      for (const target of resourcesTargets) {
        this.maxApiVersion = maximum([target.apiVersion, this.maxApiVersion]);
        this.profilesApiVersions.push(target.apiVersion);
        const apiVersion = target.apiVersion;
        const profile = target.profile;
        const weight = target.matches.length;
        const pathRegex = this.getPathRegex(target.matches);
        this.filterTargets.push({ apiVersion, profile, pathRegex, weight });
      }

      for (const target of operationTargets) {
        const apiVersion = target.apiVersion;
        const profile = target.profile;
        const pathRegex = new RegExp(`^${target.path.replace(/[\[\$\.\?\(\)]/g, "\\$&")}$`, "gi");
        this.filterTargets.push({ apiVersion, profile, pathRegex, weight: 0 });
      }
    } else if (this.apiVersions.length > 0) {
      this.maxApiVersion = maximum([this.maxApiVersion, maximum(this.apiVersions)]);
    }

    // visit schemas and extract polymorphic references.
    // Since the input is a tree-shaken document, anyOf, allOf, oneOf and not
    // should be superficial fields in the schema (i.e. not nested)
    if (this.components && this.components.schemas) {
      for (const { value: schemaValue, key: schemaKey } of visit(this.components.schemas)) {
        for (const { value: fieldValue, key: fieldName } of visit(schemaValue)) {
          switch (fieldName) {
            case "anyOf":
            case "allOf":
            case "oneOf":
              for (const { value } of visit(fieldValue)) {
                if (value.$ref) {
                  const schemaUid = value.$ref.split("/")[value.$ref.split("/").length - 1];
                  if (this.polymorphicReferences[schemaUid] === undefined) {
                    this.polymorphicReferences[schemaUid] = new Set<string>();
                  }

                  this.polymorphicReferences[schemaUid].add(schemaKey);
                }
              }
              break;
            case "not":
              if (fieldValue.$ref) {
                const schemaUid = fieldValue.$ref.split("/")[fieldValue.$ref.split("/").length - 1];
                if (this.polymorphicReferences[schemaUid] === undefined) {
                  this.polymorphicReferences[schemaUid] = new Set<string>();
                }

                this.polymorphicReferences[schemaUid].add(schemaKey);
              }
              break;
            default:
              // nothing to do
              break;
          }
        }
      }
    }

    // crawl paths and keep everything referenced by them.
    const paths = this.newObject(this.generated, "paths", "/paths");
    this.visitPaths(paths, visit(currentDoc["paths"]));

    // visit schemas that were marked to be kept
    if (this.components && this.components.schemas) {
      // create queue of stuff to check
      const polyReferencedSchemasToCheck = new Array<string>();
      const polyReferencedSchemasChecked = new Set<string>();
      const prevSchemasToKeep = new Set<string>();
      for (const schemaUid of this.componentsToKeep.schemas) {
        // populate set and queue
        prevSchemasToKeep.add(schemaUid);
        if (this.polymorphicReferences[schemaUid] !== undefined) {
          polyReferencedSchemasToCheck.push(schemaUid);
        }
      }

      while (polyReferencedSchemasToCheck.length > 0) {
        const referencedSchemaUid = polyReferencedSchemasToCheck.pop();
        if (referencedSchemaUid !== undefined) {
          polyReferencedSchemasChecked.add(referencedSchemaUid);
          for (const polyRef of this.polymorphicReferences[referencedSchemaUid].values()) {
            this.componentsToKeep.schemas.add(polyRef);
            this.crawlObject(this.components.schemas[polyRef]);
            if (prevSchemasToKeep.size !== this.componentsToKeep.schemas.size) {
              const difference = new Set([...this.componentsToKeep.schemas].filter((x) => !prevSchemasToKeep.has(x)));

              for (const newSchemaUid of difference) {
                prevSchemasToKeep.add(newSchemaUid);
                if (
                  this.polymorphicReferences[newSchemaUid] !==
                  undefined /* && !polyReferencedSchemasChecked.has(referencedSchemaUid) */
                ) {
                  polyReferencedSchemasToCheck.push(newSchemaUid);
                }
              }
            }
          }
        }
      }
    }
  }

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "info": {
          const info = <oai.Info>targetParent.info || this.newObject(targetParent, "info", pointer);
          this.visitInfo(info, children);
          break;
        }
        case "components":
          {
            const components =
              <oai.Components>targetParent.components || this.newObject(targetParent, "components", pointer);
            this.visitComponents(components, children);
          }
          break;

        case "paths":
          // already handled at init()
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  public async finish() {
    // Put in the metadata all the profiles that were actually used.
    // This excludes paths that did not match any operation.
    if (this.profilesReferenced.size !== 0) {
      this.generated.info["x-ms-metadata"].profiles = [...this.profilesReferenced];
    }
  }

  visitInfo(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { value, key, pointer } of nodes) {
      switch (key) {
        case "version":
          this.clone(targetParent, key, pointer, this.maxApiVersion);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitPath(targetParent: AnyObject, nodes: Iterable<Node>, pathMetadata: PathMetadata) {
    for (const { value, key, pointer } of nodes) {
      switch (key) {
        case "x-ms-metadata":
          this.clone(targetParent, key, pointer, pathMetadata);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {
    // sort targets by priority
    this.filterTargets.sort((a, b) => {
      return a.weight > b.weight ? -1 : a.weight < b.weight ? 1 : 0;
    });

    // map of '${profileName}:${value[x-ms-metadata].path}' -> '${path:uid} (no method included, like path:0.get, path:0.put, etc)'
    const uniquePathPerProfile = new Dictionary<string>();

    // filter paths
    for (const { value, key: pathKey, pointer, children } of nodes) {
      const path: string = value["x-ms-metadata"].path.replace(/\/*$/, "");
      const keyWithNoMethod = pathKey.split(".")[0];
      const originalApiVersions: Array<string> = value["x-ms-metadata"].apiVersions;
      const profiles = new Dictionary<string>();
      const apiVersions = new Set<string>();

      let match = false;
      if (this.filterTargets.length > 0) {
        // Profile Mode
        for (const each of values(this.filterTargets)) {
          const id = `${each.profile}:${path}`;
          if (
            path.match(each.pathRegex) &&
            originalApiVersions.includes(each.apiVersion) &&
            uniquePathPerProfile[id] === undefined
          ) {
            uniquePathPerProfile[id] = keyWithNoMethod;
          }

          if (
            path.match(each.pathRegex) &&
            originalApiVersions.includes(each.apiVersion) &&
            uniquePathPerProfile[id] === keyWithNoMethod
          ) {
            uniquePathPerProfile;
            match = true;
            this.profilesReferenced.add(each.profile);
            profiles[each.profile] = each.apiVersion;
            apiVersions.add(each.apiVersion);
          }
        }
      } else {
        // apiversion mode
        for (const targetApiVersion of this.apiVersions) {
          if (originalApiVersions.includes(targetApiVersion)) {
            match = true;
            apiVersions.add(targetApiVersion);
          }
        }
      }

      if (match) {
        const metadata: PathMetadata = {
          apiVersions: [...apiVersions],
          profiles,
          path,
          filename: value["x-ms-metadata"].filename,
          originalLocations: value["x-ms-metadata"].originalLocations,
        };

        this.visitPath(this.newObject(targetParent, pathKey, pointer), children, metadata);
      }
    }

    // crawl the paths kept, and keep the schemas referenced by them
    for (const { value } of visit(targetParent)) {
      const { "x-ms-metadata": XMsMetadata, ...path } = value;
      this.crawlObject(path);
    }
  }

  private crawlObject(obj: any): void {
    for (const { key, value } of visit(obj)) {
      if (key === "$ref") {
        const refParts = value.split("/");
        const componentUid = refParts.pop();
        const type: componentType = refParts.pop();
        if (!this.visitedComponents[type].has(componentUid)) {
          this.visitedComponents[type].add(componentUid);
          this.componentsToKeep[type].add(componentUid);
          this.crawlObject(this.components[type][componentUid]);
        }
      } else if (value && typeof value === "object") {
        this.crawlObject(value);
      }
    }
  }

  visitComponents(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case "schemas":
        case "responses":
        case "parameters":
        case "examples":
        case "requestBodies":
        case "headers":
        case "links":
          // everything else, just copy recursively.
          if (targetParent[key] === undefined) {
            this.newObject(targetParent, key, pointer);
          }

          this.visitComponent(key, targetParent[key], children);
          break;
        case "securitySchemes":
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer } of nodes) {
      if (this.componentsToKeep[type as keyof ComponentTracker].has(key)) {
        this.clone(container, key, pointer, value);
      }
    }
  }

  // matches is an array where the first element is the namespace (i.e. provider),
  // and the subsequent elements are resources_types.
  // Regex will match anything in the form (/...)/namespace(/...)/resourceType1(/...)/resourceType2(/...).../resourceTypeN(/...)
  getPathRegex(matches: Array<string>): RegExp {
    const fragment = "(\\/([^\\/?#]+))*";
    let regexString = `^${fragment}`;

    for (const word of matches) {
      const escapedWord = word.replace(/(\.)/g, (substring, p1): string => {
        return `\\${p1}`;
      });

      regexString = `${regexString}\\/${escapedWord}${fragment}`;
    }

    return RegExp(`${regexString}$`, "gi");
  }
}

async function filter(config: AutorestContext, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async (x) => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const allProfileDefinitions = config.GetEntry("profiles");
    const configApiVersion = config.GetEntry("api-version");
    const apiVersions: Array<string> = configApiVersion
      ? typeof configApiVersion === "string"
        ? [configApiVersion]
        : configApiVersion
      : [];
    const profilesRequested = !Array.isArray(config.GetEntry("profile"))
      ? [config.GetEntry("profile")]
      : config.GetEntry("profile");
    if (profilesRequested.length > 0 || apiVersions.length > 0) {
      if (profilesRequested.length > 0) {
        validateProfiles(allProfileDefinitions);
      }

      const processor = new ProfileFilter(each, allProfileDefinitions, profilesRequested, apiVersions);
      const output = await processor.getOutput();
      const specsReferencedBeforeFiltering = getFilesUsed(visit(await each.ReadObject<AnyObject>()));
      const specsReferencedAfterFiltering = getFilesUsed(visit(output));
      const specsNotUsed = [...specsReferencedBeforeFiltering].filter((x) => !specsReferencedAfterFiltering.has(x));
      if (
        (Array.isArray(config.GetEntry("output-artifact")) &&
          config.GetEntry("output-artifact").includes("profile-filter-log")) ||
        config.GetEntry("output-artifact") === "profile-filter-log"
      ) {
        result.push(
          await sink.WriteData(
            "profile-filter-log.yaml",
            serialize({ "files-used": [...specsReferencedAfterFiltering], "files-not-used": [...specsNotUsed] }),
            [],
            "profile-filter-log",
          ),
        );
      }

      result.push(
        await sink.WriteObject(
          "oai3.profile-filtered.json",
          output,
          each.identity,
          "openapi3-document-profile-filtered",
          await processor.getSourceMappings(),
        ),
      );
    } else {
      result.push(each);
    }
  }

  return new QuickDataSource(result, input.pipeState);
}

function getFilesUsed(nodes: Iterable<Node>) {
  const filesUsed = new Set<string>();
  for (const field of nodes) {
    switch (field.key) {
      case "paths":
        for (const path of field.children) {
          path.value["x-ms-metadata"].originalLocations.map((x: string) =>
            filesUsed.add(x.replace(/(.*)#\/paths.*/g, "$1")),
          );
        }
        break;

      case "components":
        for (const collection of field.children) {
          switch (collection.key) {
            case "schemas":
            case "responses":
            case "parameters":
            case "examples":
            case "requestBodies":
            case "headers":
            case "links":
            case "callbacks":
            case "securitySchemes":
              for (const component of collection.children) {
                component.value["x-ms-metadata"].originalLocations.map((x: any) =>
                  filesUsed.add(x.replace(/(.*)#\/components.*/g, "$1")),
                );
              }
              break;
            default:
              break;
          }
        }

        break;
      default:
        break;
    }
  }

  return filesUsed;
}

function validateProfiles(profiles: Dictionary<Profile>) {
  // A resourceType shouldn't be included in two apiversions within the same provider namespace in the same profile.
  const duplicatedResources = new Dictionary<Array<string>>();
  const resourcesFound = new Set<string>();
  for (const profile of items(profiles)) {
    for (const namespace of items(profile.value.resources)) {
      for (const apiVersion of items(namespace.value)) {
        for (const resource of apiVersion.value) {
          const uid = `profile:${profile.key.toLowerCase()}/providerNamespace:${namespace.key.toLowerCase()}/resourceType:${resource.toLowerCase()}`;
          if (!resourcesFound.has(uid)) {
            resourcesFound.add(uid);
          } else {
            if (duplicatedResources[uid] === undefined) {
              duplicatedResources[uid] = [];
            }

            duplicatedResources[uid].push(apiVersion.key);
          }
        }
      }
    }
  }

  if (Object.keys(duplicatedResources).length > 0) {
    let errorMessage =
      "The following resourceTypes are defined in multiple api-versions within the same providerNamespace in the same profile: ";
    for (const resourceType of items(duplicatedResources)) {
      errorMessage += `\n*${resourceType.key}:`;
      for (const duplicateEntry of resourceType.value) {
        errorMessage += `\n ---> conflicting api-versions: ${duplicateEntry}`;
      }
    }
    throw Error(errorMessage);
  }
}

interface Profile {
  resources: {
    [providerNamespace: string]: {
      [apiVersion: string]: Array<string>;
    };
  };
  operations: {
    [path: string]: string;
  };
}

/* @internal */
export function createProfileFilterPlugin(): PipelinePlugin {
  return filter;
}
