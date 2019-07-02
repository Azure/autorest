import { DataSink, DataSource, Transformer, Node, ProxyObject, QuickDataSource, visit, AnyObject, DataHandle } from '@microsoft.azure/datastore';
import { clone, Dictionary, values } from '@microsoft.azure/linq';

import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

/**
 * Takes multiple input OAI3 files and creates one merged one.
 *
 * - Creates a new unified json file
 * - for all operations and components it will add 'x-ms-metadata' section in each node:
 *   x-ms-metadata:
 *     key: /path
 *     api-version: [2018-01-01]
 *     original-file: file:///foo/bar/bin/baz.json
 *     [... yada-yada-yada ]
 *
 * - in all dictionary objects, moves the key from the dictionary item and places it in a x-ms-key member inside the dictionary item
 *   ie:
 *   paths:
 *      "/pet":
 *        ...
 *      "/user":
 *        ...
 *      "/store":
 *        ...
 *
 *   paths:
 *      "1":
 *        x-ms-key: "/pet"
 *        x-ms-metadata :
 *          api-versions: [ 2018-01-01, 2018-05-05 ]
 *          original-file: file:///foo/bar/bin/baz.json
 *        ...
 *      "1":
 *        x-ms-key: "/pet"
 *        ...
 *      "2":
 *        x-ms-key : "/user"
 *        ...
 *      "3":
 *        x-ms-key: "/store"
 *        ...
 *
 *  - rewrite all $refs to point to the new locaiton.
 *
 *  - on files that are marked 'x-ms-secondary', this will only pull in things in /components (and it marks them x-ms-secondary-file: true)
 *
 */
export class MultiAPIMerger extends Transformer<any, oai.Model> {
  opCount: number = 0;
  cCount = new Dictionary<number>();
  refs = new Dictionary<string>();

  descriptions = new Set();
  apiVersions = new Set();
  titles = new Set();

  constructor(input: Array<DataHandle>, protected overrideTitle: string | undefined, protected overrideDescription: string | undefined) {
    super(input);
  }

  /**
   * returns true when the current source file is marked x-ms-secondary-file: true
   */
  protected get isSecondaryFile(): boolean {
    return this.current['x-ms-secondary-file'] === true;
  }

  protected get info() {
    return <AnyObject>this.getOrCreateObject(this.generated, 'info', '/info');
  }

  protected get metadata() {
    return <AnyObject>this.getOrCreateObject(this.info, 'x-ms-metadata', '/');
  }

  public async process(target: ProxyObject<oai.Model>, nodes: Iterable<Node>) {

    for (const { key, value, pointer, children } of nodes) {
      switch (key) {
        case 'paths':
          if (!this.isSecondaryFile) {
            const paths = <oai.PathItem>target.paths || this.newObject(target, 'paths', pointer);
            this.visitPaths(paths, children);
          }
          break;

        case 'components':
          const components = <oai.Components>target.components || this.newObject(target, 'components', pointer);
          this.visitComponents(components, children);
          break;

        case 'servers':
        case 'security':
        case 'tags':
          if (!this.isSecondaryFile) {
            const array = <any>target[key] || this.newArray(target, key, pointer);
            for (const item of children) {
              array.__push__({
                value: item.value,
                pointer: item.pointer,
                recurse: true
              });
            }
          }
          break;

        case 'info':
          if (!this.isSecondaryFile) {
            const info = <AnyObject>this.getOrCreateObject(target, 'info', pointer);
            this.visitInfo(info, children);
          }

          break;

        case 'externalDocs':
          if (!this.isSecondaryFile) {
            if (!target.externalDocs) {
              const docs = this.newObject(target, 'externalDocs', pointer);
              for (const child of children) {
                this.copy(docs, child.key, child.pointer, child.value, true);
              }
            }
            const docsMetadata = (<oai.ExternalDocumentation>target.externalDocs)['x-ms-metadata'] || this.newArray(<oai.ExternalDocumentation>target.externalDocs, 'x-ms-metadata', pointer);
            docsMetadata.__push__({
              value: clone(value),
              pointer,
              recurse: true
            });
          }
          break;

        case 'openapi':
          if (!this.isSecondaryFile) {
            if (!target.openapi) {
              this.copy(target, key, pointer, value);
            }
          }
          break;

        default:
          if (!this.isSecondaryFile) {
            if (!target[key]) {
              this.copy(target, key, pointer, value);
            }
          }
          break;
      }
    }

    // after each file, we have to go fix up local references to be absolute references
    // just in case it wasn't done before we got here.
    this.expandRefs(this.generated);
  }

  visitInfo(info: ProxyObject<Dictionary<oai.Info>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer } of nodes) {
      switch (key) {
        case 'title':
          this.titles.add(value);
          break;
        case 'description':
          this.descriptions.add(value);
          break;
        case 'version':
          this.apiVersions.add(value);
          break;
        case 'x-ms-metadata':
          // do nothing. This is handled at finish()
          break;
        default:
          if (!info[key]) {
            this.clone(info, key, pointer, value);
          }

          break;

      }
    }
  }

  protected expandRefs(node: any) {
    for (const { value } of visit(node)) {
      if (value && typeof value === 'object') {
        const ref = value.$ref;
        if (ref && ref.startsWith('#')) {
          const fullRef = `${(<DataHandle>this.currentInput).originalFullPath}${ref}`;
          // change local refs to full ref
          value.$ref = fullRef;
          if (this.refs[ref]) {
            this.refs[fullRef] = this.refs[ref];
          }
        }

        // now, recurse into this object
        this.expandRefs(value);
      }
    }
  }

  public async finish() {
    const info = <AnyObject>this.generated.info;
    // set the document's info that we haven't processed yet.
    if (this.overrideTitle) {
      info.title = { value: this.overrideTitle, pointer: '/info/title', filename: this.currentInputFilename };
    } else {
      const titles = [...this.titles.values()];

      if (titles.length === 0) {
        throw new Error(`No 'title' in provided OpenAPI definition(s).`);
      }
      if (titles.length > 1) {
        throw new Error(`The 'title' across provided OpenAPI definitions has to match. Found: ${titles.map(x => `'${x}'`).join(', ')}. Please adjust or provide an override (--title=...).`);
      }
      info.title = { value: titles[0], pointer: '/info/title', filename: this.currentInputFilename };
    }

    if (this.overrideDescription) {
      info.description = { value: this.overrideDescription, pointer: '/info/description', filename: this.currentInputFilename };
    } else {
      const descriptions = [...this.descriptions.values()];
      if (descriptions[0]) {
        info.description = { value: descriptions[0], pointer: '/info/description', filename: this.currentInputFilename };
      }
    }
    const versions = [...this.apiVersions.values()];
    this.metadata.apiVersions = { value: versions, pointer: '/' };
    info.version = { value: versions[0], pointer: '/info/version' } // todo: should this be the max version?

    // walk thru the generated document, find all the $refs and update them to the new location
    this.updateRefs(this.generated);
  }

  protected updateRefs(node: any) {
    for (const { key, value } of visit(node)) {
      if (value && typeof value === 'object') {
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

  visitPaths(paths: ProxyObject<Dictionary<oai.PathItem>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      const uid = `path:${this.opCount++}`;

      // tag the current pointer with a the new location
      const originalLocation = `${(<DataHandle>this.currentInput).originalFullPath}#${pointer}`;
      this.refs[originalLocation] = `#/paths/${uid}`;

      // for testing with local refs
      this.refs[`#${pointer}`] = `#/paths/${uid}`;

      // create a new pathitem (use an index# instead of the path)
      const operation = this.newObject(paths, `${uid}`, pointer);
      const metadata = {
        value: {
          apiVersions: [this.current.info && this.current.info.version ? this.current.info.version : ''], // track the API version this came from
          filename: [this.currentInputFilename],                       // and the filename
          path: key,	                                // and here is the path from the operation.
          originalLocations: [originalLocation]
        }, pointer
      };

      operation['x-ms-metadata'] = metadata;

      // now, let's copy the rest of the operation into the operation object
      for (const child of children) {
        // check if operation if not is common and should be put in each one.
        switch (child.key) {
          case 'get':
          case 'put':
          case 'post':
          case 'delete':
          case 'options':
          case 'head':
          case 'patch':
          case 'trace':
            const childOperation = this.newObject(paths, `${uid}.${child.key}`, pointer);
            childOperation['x-ms-metadata'] = clone(metadata);
            this.copy(childOperation, child.key, child.pointer, child.value);
            if (value.parameters) {
              if (childOperation[child.key].parameters) {
                childOperation[child.key].parameters.unshift(...value.parameters);
              } else {
                childOperation[child.key].parameters = clone(value.parameters);
              }
            }
            break;
          case 'parameters':
          // they are placed at the beginning of the array parameters per operation.
          default:
            // for now skipping until we support all OA3 features.
            break;
        }
      }
    }
  }
  visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      // NOTE: SecuritySchemes are not being used anywhere in AutoRest.
      // So, to reduce overhead in RPs with hundreds of swaggers we drop them.
      if (key !== 'securitySchemes') {
        this.cCount[key] = this.cCount[key] || 0;
        if (components[key] === undefined) {
          this.newObject(components, key, pointer);
        }

        this.visitComponent(key, components[key], children);
      }
    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {

      const uid = `${type}:${this.cCount[type]++}`;

      // tag the current pointer with a the new location
      const originalLocation = `${(<DataHandle>this.currentInput).originalFullPath}#${pointer}`;
      const localRef = `#/components/${type}/${uid}`;
      this.refs[originalLocation] = localRef;
      // for testing with local refs
      this.refs[`#${pointer}`] = localRef;

      // for enums we need to use the name from the x-ms-enum. Otherwise, we can get collisions later on.
      const name = (type === 'schemas' && value['x-ms-enum'] !== undefined && value['x-ms-enum'].name !== undefined) ? value['x-ms-enum'].name : key;

      const component: AnyObject = this.newObject(container, `${uid}`, pointer);
      component['x-ms-metadata'] = {
        value: {
          apiVersions: [this.current.info && this.current.info.version ? this.current.info.version : ''], // track the API version this came from
          filename: [this.currentInputFilename],                       // and the filename
          name,
          originalLocations: [originalLocation],
          'x-ms-secondary-file': this.isSecondaryFile
        }, pointer
      };

      for (const child of children) {
        this.copy(component, child.key, child.pointer, child.value);
      }
    }
  }
}

async function merge(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(x => input.ReadStrict(x)));

  const overrideInfo = config.GetEntry('override-info');
  const overrideTitle = (overrideInfo && overrideInfo.title) || config.GetEntry('title');
  const overrideDescription = (overrideInfo && overrideInfo.description) || config.GetEntry('description');

  const processor = new MultiAPIMerger(inputs, overrideTitle, overrideDescription);

  return new QuickDataSource([await sink.WriteObject('merged oai3 doc...', await processor.getOutput(), [].concat.apply([], inputs.map(each => each.identity) as any), 'merged-oai3', await processor.getSourceMappings())], input.skip);
}

/* @internal */
export function createMultiApiMergerPlugin(): PipelinePlugin {
  return merge;
}
