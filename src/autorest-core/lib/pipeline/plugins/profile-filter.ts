/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { AnyObject, DataHandle, DataSink, DataSource, Node, Transformer, ProxyObject, QuickDataSource, visit } from '@microsoft.azure/datastore';
import { Dictionary } from '@microsoft.azure/linq';
import * as oai from '@microsoft.azure/openapi';
import * as compareVersions from 'compare-versions';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

interface ApiData {
  apiVersion: string;
  profile: string;
  matches: Array<string>;
}

type componentType = 'schemas' | 'responses' | 'parameters' | 'examples' | 'requestBodies' | 'headers' | 'securitySchemes' | 'links' | 'callbacks';

function getMaxApiVersion(apiVersions: Array<string>): string {
  let result = '0';
  for (const version of apiVersions) {
    if (version && compareVersions(getSemverEquivalent(version), getSemverEquivalent(result)) >= 0) {
      result = version;
    }
  }

  return result;
}

// azure rest specs currently use versioning of the form yyyy-mm-dd
// to take into consideration this we convert to an equivalent of
// semver for comparisons.
function getSemverEquivalent(version: string) {
  let result = '';
  for (const i of version.split('-')) {
    if (!result) {
      result = i;
      continue;
    }
    result = Number.isNaN(Number.parseInt(i)) ? `${result}-${i}` : `${result}.${i}`;
  }
  return result;
}

interface pathMetadata {
  apiVersions: Array<string>;
  filename: Array<string>;
  path: string;
  profiles: Dictionary<string>;
  originalLocations: Array<string>;
}

export class ProfileFilter extends Transformer<any, oai.Model> {
  filterTargets: Array<{ apiVersion: string; profile: string; pathRegex: RegExp }> = [];

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
    callbacks: new Set<string>()
  };

  private componentsToKeep = {
    schemas: new Set<string>(),
    responses: new Set<string>(),
    parameters: new Set<string>(),
    examples: new Set<string>(),
    requestBodies: new Set<string>(),
    headers: new Set<string>(),
    securitySchemes: new Set<string>(),
    links: new Set<string>(),
    callbacks: new Set<string>()
  };

  private components: any;
  private profilesApiVersions: Array<string> = [];
  private apiVersions: Array<string> = [];
  private maxApiVersion: string = '';

  constructor(input: DataHandle, private profiles: any, private profilesToUse: Array<string>, apiVersions: Array<string>) {
    super(input);
    this.apiVersions = apiVersions;
  }

  async init() {
    const currentDoc = this.inputs[0].ReadObject();
    this.components = currentDoc['components'];
    if (this.profilesToUse.length > 0) {
      const targets: Array<ApiData> = [];
      for (const { key: profileName, value: resourceProvider } of visit(this.profiles)) {
        if (this.profilesToUse.includes(profileName)) {
          for (const { key: namespace, value: namespaceValue } of visit(resourceProvider)) {
            for (const { key: version, value: resourceTypes } of visit(namespaceValue)) {
              if (resourceTypes.length === 0) {
                targets.push({ apiVersion: version, profile: profileName, matches: [namespace] });
              } else {
                for (const resourceType of resourceTypes) {
                  targets.push({ apiVersion: version, profile: profileName, matches: [namespace, ...resourceType.split('/')] });
                }
              }
            }
          }
        }
      }

      for (const target of targets) {
        this.maxApiVersion = getMaxApiVersion([target.apiVersion, this.maxApiVersion]);
        this.profilesApiVersions.push(target.apiVersion);
        const apiVersion = target.apiVersion;
        const profile = target.profile;
        const pathRegex = this.getPathRegex(target.matches);
        this.filterTargets.push({ apiVersion, profile, pathRegex });
      }

    } else if (this.apiVersions.length > 0) {
      this.maxApiVersion = getMaxApiVersion([this.maxApiVersion, getMaxApiVersion(this.apiVersions)]);
    }

    const paths = this.newObject(this.generated, 'paths', '/paths');
    this.visitPaths(paths, visit(currentDoc['paths']));
  }

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'info':
          const info = <oai.Info>targetParent.info || this.newObject(targetParent, 'info', pointer);
          this.visitInfo(info, children);
        case 'components':
          const components = <oai.Components>targetParent.components || this.newObject(targetParent, 'components', pointer);
          this.visitComponents(components, children);
          break;

        case 'paths':
          // already handled at init()
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitInfo(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of nodes) {
      switch (key) {
        case 'version':
          this.clone(targetParent, key, pointer, this.maxApiVersion);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitPath(targetParent: AnyObject, nodes: Iterable<Node>, pathMetadata: pathMetadata) {
    for (const { value, key, pointer } of nodes) {
      switch (key) {
        case 'x-ms-metadata':
          this.clone(targetParent, key, pointer, pathMetadata);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }

    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {
    // filter paths
    for (const { value, key, pointer, children } of nodes) {
      const path: string = value['x-ms-metadata'].path;
      const originalApiVersions: Array<string> = value['x-ms-metadata'].apiVersions;
      const profiles = new Dictionary<string>();
      const apiVersions = new Set<string>();

      let match = false;

      if (this.filterTargets.length > 0) {
        // Profile Mode
        for (const each of this.filterTargets) {
          if (path.replace(/\/*$/, '').match(each.pathRegex) && originalApiVersions.includes(each.apiVersion)) {
            match = true;
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
        const metadata: pathMetadata = {
          apiVersions: [...apiVersions],
          profiles,
          path,
          filename: value['x-ms-metadata'].filename,
          originalLocations: value['x-ms-metadata'].originalLocations
        }

        this.visitPath(this.newObject(targetParent, key, pointer), children, metadata);
      }
    }

    // crawl the paths kept, and keep the schemas referenced by them
    for (const { value } of visit(targetParent)) {
      const { 'x-ms-metadata': XMsMetadata, ...path } = value;
      this.crawlObject(path);
    }
  }

  private crawlObject(obj: any): void {
    for (const { key, value } of visit(obj)) {
      if (key === '$ref') {
        const refParts = value.split('/');
        const componentUid = refParts.pop();
        const type: componentType = refParts.pop();
        if (!this.visitedComponents[type].has(componentUid)) {
          this.visitedComponents[type].add(componentUid);
          this.componentsToKeep[type].add(componentUid);
          this.crawlObject(this.components[type][componentUid]);
        }
      } else if (value && typeof (value) === 'object') {
        this.crawlObject(value);
      }
    }
  }

  visitComponents(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'schemas':
        case 'responses':
        case 'parameters':
        case 'examples':
        case 'requestBodies':
        case 'headers':
        case 'links':
          // everything else, just copy recursively.
          if (targetParent[key] === undefined) {
            this.newObject(targetParent, key, pointer);
          }

          this.visitComponent(key, targetParent[key], children);
          break;
        case 'securitySchemes':
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer } of nodes) {
      if (this.componentsToKeep[type].has(key)) {
        this.clone(container, key, pointer, value);
      }
    }
  }

  getPathRegex(matches: Array<string>): RegExp {
    const fragment = '(\/([^\/?#]+))*';
    let regexString = `^${fragment}`;

    for (const word of matches) {
      const escapedWord = word.replace(/(\.)/g, (substring, p1): string => {
        return `\\${p1}`;
      });

      regexString = `${regexString}/${escapedWord}${fragment}`;
    }

    return RegExp(`${regexString}$`);
  }
}

async function filter(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];

  for (const each of inputs) {
    const profileData = config.GetEntry('profiles');

    const configApiVersion = config.GetEntry('api-version');
    const apiVersions: Array<string> = configApiVersion ? (typeof (configApiVersion) === 'string') ? [configApiVersion] : configApiVersion : [];

    const configUseProfile = config.GetEntry('profile');
    const profilesToUse: Array<string> = configUseProfile ? (typeof (configUseProfile) === 'string') ? [configUseProfile] : configUseProfile : [];
    if (profilesToUse.length > 0 || apiVersions.length > 0) {
      const processor = new ProfileFilter(each, profileData, profilesToUse, apiVersions);
      result.push(await sink.WriteObject('profile-filtered-oai-doc...', await processor.getOutput(), each.identity, 'profile-filtered-oai-doc...', await processor.getSourceMappings()));
    } else {
      result.push(each);
    }
  }

  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createProfileFilterPlugin(): PipelinePlugin {
  return filter;
}
