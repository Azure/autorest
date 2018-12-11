import { AnyObject, DataHandle, DataSink, DataSource, MultiProcessor, Node, ProxyObject, QuickDataSource, visit, Processor, ProxyNode } from '@microsoft.azure/datastore';
import { values, Dictionary, keys } from '@microsoft.azure/linq';

import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { areSimilar } from "@microsoft.azure/object-comparison";

require('source-map-support').install();

function distinct<T>(list: Array<T>): Array<T> {
  const sorted = list.slice().sort();
  return sorted.filter((x, i) => i === 0 || x !== sorted[i - 1]);
}

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

export class NewComposer extends Processor<AnyObject, AnyObject> {
  private uniqueVersion!: boolean;
  refs = new Dictionary<string>();


  constructor(input: DataHandle, protected overrideTitle: string | undefined, protected overrideDescription: string | undefined) {
    super(input);
  }

  get components(): AnyObject {
    if (this.generated.components) {
      return this.generated.components;
    }
    if (this.current.components) {
      return this.newObject(this.generated, 'components', '/components');
    }
    return this.newObject(this.generated, 'components', '/');
  }

  get paths(): AnyObject {
    if (this.generated.paths) {
      return this.generated.paths;
    }
    if (this.current.paths) {
      return this.newObject(this.generated, 'paths', '/paths');
    }
    return this.newObject(this.generated, 'paths', '/');
  }

  private componentItem(key: string) {
    return this.components[key] ? this.components[key] :
      (this.current.components && this.current.components[key]) ?
        this.newObject(this.components, key, `/components/${key}`) :
        this.newObject(this.components, key, '/');
  }

  get schemas(): AnyObject {
    return this.componentItem('schemas');
  }
  get responses(): AnyObject {
    return this.componentItem('responses');
  }
  get parameters(): AnyObject {
    return this.componentItem('parameters');
  }
  get examples(): AnyObject {
    return this.componentItem('examples');
  }
  get requestBodies(): AnyObject {
    return this.componentItem('requestBodies');
  }
  get headers(): AnyObject {
    return this.componentItem('headers');
  }
  get securitySchemes(): AnyObject {
    return this.componentItem('securitySchemes');
  }
  get links(): AnyObject {
    return this.componentItem('links');
  }
  get callbacks(): AnyObject {
    return this.componentItem('callbacks');
  }

  /**
   * returns true when the current source file is marked x-ms-secondary-file: true
   */
  protected get isSecondaryFile(): boolean {
    return this.current['x-ms-secondary-file'] === true;
  }

  public async process(target: ProxyObject<AnyObject>, nodes: Iterable<Node>) {
    const metadata = this.current.info ? this.current.info['x-ms-metadata'] : [];

    this.generated.openapi = { value: '3.0.0', pointer: '', filename: this.key };
    this.newObject(this.generated, 'info', '/info');

    // title for the document.
    if (this.overrideTitle) {
      this.generated.info.title = { value: this.overrideTitle, pointer: '/info/title', filename: this.key };
    } else {
      // iterate thru the files to get a list of titles.
      const titles = distinct(metadata.map(each => each.title).filter(i => !!i));

      if (titles.length === 0) {
        throw new Error(`No 'title' in provided OpenAPI definition(s).`);
      }
      if (titles.length > 1) {
        throw new Error(`The 'title' across provided OpenAPI definitions has to match. Found: ${titles.map(x => `'${x}'`).join(', ')}. Please adjust or provide an override (--title=...).`);
      }
      this.generated.info.title = { value: titles[0], pointer: '/info/title', filename: this.key };
    }

    // description for the document.
    if (this.overrideDescription) {
      this.generated.info.description = { value: this.overrideDescription, pointer: '/info/description', filename: this.key };
    } else {
      const descriptions = distinct(metadata.map(each => each.description).filter(i => !!i));
      if (descriptions[0]) {
        this.generated.info.description = { value: descriptions[0], pointer: '/info/description', filename: this.key };
      }
    }

    const versions = distinct(metadata.map(each => each.version).filter(i => !!i));
    this.uniqueVersion = versions.length > 1 ? false : true;

    // version for the document
    this.generated.info.version = { value: versions[0], pointer: '/info/version' };

    for (const { key, value, pointer, children } of nodes) {

      switch (key) {
        case 'paths':
          break;

        case 'components':
          this.visitComponents(this.components, children);
          break;

        case 'openapi':
        case 'info':
          // ignore these. We've already handled them.
          break;

        case 'servers':
          this.clone(target, key, pointer, value);
          break;

        default:
          if (!this.isSecondaryFile) {
            // nodes must just merge without collsion
            this.cloneInto(<AnyObject>this.getOrCreateObject(target, key, pointer), children);
          }
          break;

      }
    }
  }

  public async finish() {
    // now go thru the paths in each one of the inputs and process them.
    for (const input of values(this.inputs)) {
      this.currentInput = input;
      this.current = input.ReadObject<AnyObject>();
      if (!this.isSecondaryFile && this.current.paths) {
        this.visitPaths(this.paths, visit(this.current.paths));
      }
    }

    // and update refs to match the re-written ones (since the key has to be the actual name for older modeler)
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
      const actualPath = value['x-ms-metadata'] && value['x-ms-metadata'].path ? value['x-ms-metadata'].path : key;
      if (target[actualPath] === undefined) {
        // new object
        this.visitPath(this.newObject(target, actualPath, pointer), children);
      } else {
        if (!areSimilar(value, target[actualPath], 'x-ms-metadata', 'description', 'summary')) {
          throw new Error(`Incompatible paths conflicting: ${pointer}`);
        }
      }
    }
  }

  protected visitPath(target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      this.visitOperation(this.newObject(target, key, pointer), children);
    }
  }
  protected visitOperation(target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {

      // we have to pull thru $refs on properties' *schema* and
      switch (key) {
        case 'parameters':
          this.visitAndDerefArray(this.newArray(target, key, pointer), children);
          break;

        case 'responses':
          this.visitAndDerefObject(this.newObject(target, key, pointer), children);
          break;

        default:
          this.clone(target, key, pointer, value);
          break;
      }
    }
  }

  protected lookupRef(reference: string): AnyObject {
    // since we know that the references are all in this file
    // we should be able to find the referenced item.
    const [, path] = reference.split('#/');
    const [components, component, location] = path.split('/');
    return this.current[components][component][location];
  }

  protected visitAndDerefArray(target: AnyObject, nodes: Iterable<Node>) {
    // for each parameter
    for (const { key, value, pointer, children } of nodes) {
      // if we have more than one active api-version parameter
      // we have to remove the global one from each method
      // and implement a new one.
      if (!this.uniqueVersion) {
        // go grab the parameter from global
        if (value.$ref) {
          const param = this.lookupRef(value.$ref);

          if (param.name === 'api-version') {
            const p = JSON.parse(JSON.stringify(param));

            p.schema = {
              type: 'string',
              enum: [p['x-ms-metadata']['apiVersions'][0]]
            };
            target.__push__({ value: p, pointer, recurse: true, filename: this.key });
            continue;
          }
        }
      }
      target.__push__({ value: JSON.parse(JSON.stringify(value)), pointer, recurse: true, filename: this.key });

      /*
        if (value.$ref) {
          const parameter = this.lookupRef(value.$ref);
          if( parameter.schema && parameter.schema.$ref ) {
            // the parameter has a referenced schema.
            let's pull i
          }

          // look up the ref and clone it.
          target.__push__({ value: JSON.parse(JSON.stringify(parameter)), pointer, recurse: true, filename: this.key });
        } else {

        }
        */
    }
  }

  protected visitAndDerefObject(target: AnyObject, nodes: Iterable<Node>) {
    // for each parameter, we have to pull thru the $ref'd parameter
    for (const { key, value, pointer, children } of nodes) {

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
      if (target[key] === undefined) {
        // the value isn't in the target. We can take it from the source
        this.clone(<AnyObject>target, key, pointer, value);

        if (this.isSecondaryFile) {
          // tag this as secondary, since we may end up deleting it later.
          const xmsMeta = this.getOrCreateObject(<AnyObject>target, 'x-ms-metadata', '');
          xmsMeta['x-ms-secondary-file'] = {
            value: true, pointer: ''
          };
        }
      } else {
        if (!areSimilar(value, target[key], 'x-ms-metadata', 'description', 'summary')) {
          throw new Error(`Incompatible models conflicting: ${pointer}`);
        }
      }
    }
    return target;
  }

  protected visitSchemas(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      // schemas have to keep their name

      const schemaName = (!value['type'] || value['type'] === 'object') ? value['x-ms-metadata'].name : key;

      if (target[schemaName] === undefined) {
        // the value isn't in the target. We can take it from the source
        const schema = this.clone(target, schemaName, pointer, value).value;

        this.refs[`#/components/schemas/${key}`] = `#/components/schemas/${schemaName}`;

        if (this.isSecondaryFile) {
          // tag this as secondary, since we may end up deleting it later.
          const xmsMeta = this.getOrCreateObject(target, 'x-ms-metadata', '');
          xmsMeta['x-ms-secondary-file'] = {
            value: true, pointer: ''
          };
        }
      } else {
        if (!areSimilar(value, target[schemaName], 'x-ms-metadata', 'description', 'summary')) {
          throw new Error(`Incompatible models conflicting: ${schemaName}`);
        }
      }
    }
    return target;
  }

  protected visitParameter(parameter: ProxyObject<AnyObject>, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      switch (key) {
        case 'schema':
          if (value.$ref) {
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
      if (!this.uniqueVersion && value.name === 'api-version') {
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
        case 'schemas':
          this.visitSchemas(this.schemas, children);
          break;

        case 'responses':
          this.cloneInto(this.responses, children);
          break;

        case 'parameters':
          this.visitParameters(this.parameters, children);
          break;

        case 'examples':
          this.cloneInto(this.examples, children);
          break;

        case 'requestBodies':
          this.cloneInto(this.requestBodies, children);
          break;

        case 'headers':
          this.cloneInto(this.headers, children);
          break;

        case 'securitySchemes':
          this.cloneInto(this.securitySchemes, children);
          break;

        case 'links':
          this.cloneInto(this.links, children);
          break;

        case 'callbacks':
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

async function compose(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));

  // get the override info from the configuration
  const overrideInfo = config.GetEntry('override-info');
  const overrideTitle = (overrideInfo && overrideInfo.title) || config.GetEntry('title');
  const overrideDescription = (overrideInfo && overrideInfo.description) || config.GetEntry('description');

  // compose-a-vous!
  const composer = new NewComposer(inputs[0], overrideTitle, overrideDescription);
  return new QuickDataSource([await sink.WriteObject('composed oai3 doc...', await composer.getOutput(), [].concat.apply([], inputs.map(each => each.identity)), 'merged-oai3', await composer.getSourceMappings())], input.skip);
}

/* @internal */
export function createNewComposerPlugin(): PipelinePlugin {
  return compose;
}
