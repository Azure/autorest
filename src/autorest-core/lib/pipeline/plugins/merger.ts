import { DataSink, DataSource, MultiProcessor, Node, ProxyObject, QuickDataSource, visit, AnyObject, } from '@microsoft.azure/datastore';
import { clone, Dictionary } from '@microsoft.azure/linq';

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
export class MultiAPIMerger extends MultiProcessor<any, oai.Model> {
  opCount: number = 0;
  cCount = new Dictionary<number>();
  refs = new Dictionary<string>();

  /**
   * returns true when the current source file is marked x-ms-secondary-file: true
   */
  protected get isSecondaryFile(): boolean {
    return this.current['x-ms-secondary-file'] === true;
  }

  public process(target: ProxyObject<oai.Model>, nodes: Iterable<Node>) {

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
            if (!target.info) {
              this.newObject(target, 'info', pointer);
              for (const child of children) {
                this.copy(<oai.Info>target.info, child.key, child.pointer, child.value, true);
              }
            }
            const metadata = target.info['x-ms-metadata'] || this.newArray(<oai.Info>target.info, 'x-ms-metadata', pointer);
            metadata.__push__({
              value: clone(value),
              pointer,
              recurse: true
            });
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

  protected expandRefs(node: any) {
    for (const { value } of visit(node)) {
      if (value && typeof value === 'object') {
        const ref = value.$ref;
        if (ref && ref.startsWith('#')) {
          // change local refs to full ref
          value.$ref = `${this.currentInput.originalFullPath}${ref}`;
        }

        // now, recurse into this object
        this.expandRefs(value);
      }
    }
  }

  public finish() {
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
      const uid = this.opCount++;

      // tag the current pointer with a the new location
      const originalLocation = `${this.currentInput.originalFullPath}#${pointer}`;
      this.refs[originalLocation] = `#/paths/${uid}`;

      // for testing with local refs
      this.refs[`#${pointer}`] = `#/paths/${uid}`;

      // create a new pathitem (use an index# instead of the path)
      const operation = this.newObject(paths, `${uid}`, pointer);
      operation['x-ms-metadata'] = {
        value: {
          apiVersions: [this.current.info.version], // track the API version this came from
          filename: [this.key],                       // and the filename
          path: key,	                                // and here is the path from the operation.
          originalLocations: [originalLocation]
        }, pointer
      };

      // now, let's copy the rest of the operation into the operation object
      for (const child of children) {
        this.copy(operation, child.key, child.pointer, child.value);
      }
    }
  }
  visitComponents(components: ProxyObject<Dictionary<oai.Components>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      this.cCount[key] = this.cCount[key] || 0;
      if (components[key] === undefined) {
        this.newObject(components, key, pointer);
      }

      this.visitComponent(key, components[key], children);
    }
  }
  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {

      const uid = this.cCount[type]++;

      // tag the current pointer with a the new location
      const originalLocation = `${this.currentInput.originalFullPath}#${pointer}`;
      this.refs[originalLocation] = `#/components/${type}/${uid}`;
      // for testing with local refs
      this.refs[`#${pointer}`] = `#/components/${type}/${uid}`;

      const component: AnyObject = this.newObject(container, `${uid}`, pointer);
      component['x-ms-metadata'] = {
        value: {
          apiVersions: [this.current.info && this.current.info.version ? this.current.info.version : ''], // track the API version this came from
          filename: [this.key],                       // and the filename
          name: key,	                                // and here is the name of the component.
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
  const processor = new MultiAPIMerger(inputs);
  return new QuickDataSource([await sink.WriteObject('merged oai3 doc...', processor.output, [].concat.apply([], inputs.map(each => each.identity)), 'merged-oai3', processor.sourceMappings)], input.skip);
}

/* @internal */
export function createMultiApiMergerPlugin(): PipelinePlugin {
  return merge;
}
