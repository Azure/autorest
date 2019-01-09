import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, QuickDataSource, visit } from '@microsoft.azure/datastore';
import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

export interface ApiData {
  apiVersion: string;
  matches: Array<string>;
}

type componentType = 'schemas' | 'responses' | 'parameters' | 'examples' | 'requestBodies' | 'headers' | 'securitySchemes' | 'links' | 'callbacks';

export class ProfileFilter extends Processor<any, oai.Model> {
  filterTargets: Array<{ apiVersion: string; pathRegex: RegExp }> = [];

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

  private components: any;

  constructor(input: DataHandle, private profiles: any, private profilesToUse: Array<string>) {
    super(input);
  }

  async init() {
    const currentDoc = this.inputs[0].ReadObject();
    this.components = currentDoc['components'];
    const targets: Array<ApiData> = [];
    for (const { key: profileName, value: profile } of visit(this.profiles)) {
      if (this.profilesToUse.includes(profileName)) {
        for (const { key: namespace, value: namespaceValue } of visit(profile)) {
          for (const { key: version, value: resourceTypes } of visit(namespaceValue)) {
            if (resourceTypes.length === 0) {
              targets.push({ apiVersion: version, matches: [namespace] });
            } else {
              for (const resourceType of resourceTypes) {
                targets.push({ apiVersion: version, matches: [namespace, ...resourceType.split('/')] });
              }
            }
          }
        }
      }
    }

    for (const target of targets) {
      const apiVersion = target.apiVersion;
      const pathRegex = this.getPathRegex(target.matches);
      this.filterTargets.push({ apiVersion, pathRegex });
    }
  }

  public async process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'components':
          const components = <oai.Components>targetParent.components || this.newObject(targetParent, 'components', pointer);
          this.visitComponents(components, children);
          break;

        case 'paths':
          const paths = <oai.PathItem>targetParent.paths || this.newObject(targetParent, 'paths', pointer);
          this.visitPaths(paths, children);
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {
    // filter paths
    for (const { value, key, pointer } of nodes) {
      const path: string = value['x-ms-metadata'].path;
      const apiVersions: Array<string> = value['x-ms-metadata'].apiVersions;
      for (const each of this.filterTargets) {
        if (path.match(each.pathRegex) && apiVersions.includes(each.apiVersion)) {
          this.clone(targetParent, key, pointer, value);
        }
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
          if (type === 'schemas') {
            if (this.generated.components === undefined) {
              this.newObject(this.generated, 'components', `/components`);
            }

            if (this.generated.components && this.generated.components.schemas === undefined) {
              this.newObject(this.generated.components, 'schemas', `/components/schemas`);
            }

            if (this.generated.components && this.generated.components.schemas) {
              this.clone(this.generated.components.schemas, componentUid, `/components/schemas/${componentUid}`, this.components[type][componentUid]);
            }
          }

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

          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
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
    const profilesToUse = config.GetEntry('use-profile');
    if (profilesToUse) {
      const processor = new ProfileFilter(each, profileData, profilesToUse);
      result.push(await sink.WriteObject(each.Description, await processor.getOutput(), each.identity, each.artifactType, await processor.getSourceMappings()));
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
