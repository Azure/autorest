import { AnyObject, DataHandle, DataSink, DataSource, Transformer, Node, ProxyNode, ProxyObject, QuickDataSource, visit } from '@microsoft.azure/datastore';
import { clone, Dictionary, keys, values } from '@microsoft.azure/linq';
import { areSimilar } from "@microsoft.azure/object-comparison";
import * as oai from '@microsoft.azure/openapi';
import * as assert from 'assert';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

try {
  require('source-map-support').install();
} catch {

}

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

export class NewComposer extends Transformer<AnyObject, AnyObject> {
  private uniqueVersion!: boolean;
  refs = new Dictionary<string>();

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

  public async process(target: ProxyObject<AnyObject>, nodes: Iterable<Node>) {
    const metadata = this.current.info ? this.current.info['x-ms-metadata'] : {};

    this.uniqueVersion = metadata.apiVersions.length > 1 ? false : true;

    // version for the document
    // this.generated.info.version = { value: metadata.apiVersions.[0], pointer: '/info/version' };

    for (const { key, value, pointer, children } of nodes) {

      switch (key) {
        case 'paths':
          this.visitPaths(this.paths, children);
          break;

        case 'components':
          this.visitComponents(this.components, children);
          break;

        case 'openapi':
          // ignore these. We've already handled them.
          break;

        case 'info':
        case 'servers':
          this.clone(target, key, pointer, value);
          break;

        default:
          this.cloneInto(<AnyObject>this.getOrCreateObject(target, key, pointer), children);
          break;

      }
    }
  }

  public async finish() {
    if (this.uniqueVersion) {
      // if this is a single-api version client
      // let's add in a global parameter to make it so we don't do a binary break of the existing clients.
      this.parameters.ApiVersionParameter = {
        pointer: '/',
        value: {
          'name': 'api-version',
          'in': 'query',
          'description': 'Client API version.',
          'required': true,
          'schema': {
            'type': 'string',
            'enum': [this.current.info.version]
          }
        }

      };
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
        this.visitPath(value['x-ms-metadata'], this.newObject(target, actualPath, pointer), children);
      } else {
        // we split up the operations when we merged in order to enable the deduplicator to work it's
        // magic on the operations
        // but the older modeler needs them mereged together again
        // luckily, it won't have any $refs to the paths, so I'm not worried about fixing those up.
        this.visitPath(value['x-ms-metadata'], target[actualPath], children);
        // if (!areSimilar(value, target[actualPath], 'x-ms-metadata', 'description', 'summary')) {
        //throw new Error(`Incompatible paths conflicting: ${pointer}: ${actualPath}`);
        //}
      }
    }
  }

  protected visitPath(metadata: AnyObject, target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {
      this.visitOperation(metadata, this.getOrCreateObject(target, key, pointer), children);
    }
  }

  protected visitOperation(metadata: AnyObject, target: AnyObject, nodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of nodes) {

      // we have to pull thru $refs on properties' *schema* and
      switch (key) {
        case 'parameters':
          this.visitAndDerefArray(metadata, target, key, pointer, children);
          break;


        case 'responses':
          this.visitResponses(this.newObject(target, key, pointer), children);
          break;

        default:
          // @future_garrett -- this is done to allow paths to be re-integrated 
          // after deduplication. If this gives you problems, don't say I didn't 
          // warn you.
          if (!target[key]) {
            this.clone(target, key, pointer, value);
          }
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

  protected visitAndDerefArray(metadata: AnyObject, target: AnyObject, k: string, ptr: string, nodes: Iterable<Node>) {
    const paramarray = this.newArray(target, k, ptr);

    // for each parameter
    for (const { key, value, pointer, children } of nodes) {
      paramarray.__push__({ value: JSON.parse(JSON.stringify(value)), pointer, recurse: true, filename: this.currentInputFilename });
    }

    // if we have more than one api-version in this client
    // we have to push a constant apiversion parameter into the method.
    // if (!this.uniqueVersion) {
    const p = {
      name: 'api-version',
      in: 'query',
      description: 'The API version to use for the request.',
      required: true,
      schema: {
        type: 'string',
        enum: [metadata['apiVersions'][0]]
      }
    };

    paramarray.__push__({ value: p, pointer: ptr, recurse: true, filename: this.currentInputFilename });
    // }
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
      } else {
        if (!areSimilar(value, target[key], 'x-ms-metadata', 'description', 'summary')) {
          throw new Error(`Incompatible models conflicting: ${pointer}`);
        }
      }
    }
    return target;
  }

  protected visitResponses(responses: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      this.visitResponse(this.newObject(responses, key, pointer), children);
    }
  }

  protected visitResponse(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      switch (key) {
        case 'headers':
          // headers that are  $ref'd and we need to inline it 
          // because the imodeler1 doesn't know how to deal with that.
          this.inlineHeaders(this.newObject(target, key, pointer), children);
          break;

        default:
          this.clone(target, key, pointer, value);
          break;
      }
    }
  }

  protected inlineHeaders(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      // if the header is a $ref then we have to inline it.
      if (value.$ref) {
        const actualHeader = this.lookupRef(value.$ref);

        if (actualHeader.schema && actualHeader.schema.$ref) {
          // this has a schema that has to be derefed too.
          // this.clone(target, key, pointer, actualHeader);
          this.inlineHeaderCorrectly(this.newObject(target, key, pointer), visit(actualHeader));
        }
        else {
          // it's specified as a reference
          this.clone(target, key, pointer, actualHeader);
        }
      } else {
        this.clone(target, key, pointer, value);
      }
    }
  }

  protected inlineHeaderCorrectly(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      if (value.$ref) {
        // it's specified as a reference
        this.clone(target, key, pointer, this.lookupRef(value.$ref));
      } else {
        this.clone(target, key, pointer, value);
      }

    }
  }

  protected inlineHeader(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      if (value.$ref) {
        // it's specified as a reference
        this.visitAndDerefObject(this.newObject(target, key, pointer), children);
      } else {
        this.clone(target, key, pointer, value);
      }

    }
  }
  protected inlineHeaderSchema(header: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      switch (key) {
        case 'schema':
          if (value.$ref) {
            // header schemas have to be inlined because the imodeler1 can't handle them
            this.clone(header, key, pointer, this.lookupRef(value.$ref));
          } else {
            this.clone(header, key, pointer, value);
          }
          break;

        default:
          this.clone(header, key, pointer, value);
          break;
      }
    }
  }

  protected visitSchemas(target: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer } of originalNodes) {
      // schemas have to keep their name

      const schemaName = (!value['type'] || value['type'] === 'object') ? value['x-ms-metadata'].name : key;

      // this is pulling up the name of the schema back from the x-ms-metadata.
      // we do this because we don't want to alter the modeler
      // this is being added to the merger, since it looks like we want this behavior there too.

      if (target[schemaName] === undefined) {
        // the value isn't in the target. We can take it from the source
        const schema = this.clone(target, schemaName, pointer, value).value;
        this.refs[`#/components/schemas/${key}`] = `#/components/schemas/${schemaName}`;
      } else {
        this.refs[`#/components/schemas/${key}`] = `#/components/schemas/${schemaName}`;
        // if (!areSimilar(value, target[schemaName], 'x-ms-metadata', 'description', 'summary')) {
        //   try {
        //     const a = clone(value, false, undefined, ['x-ms-metadata', 'description', 'summary']);
        //     const b = clone(target[schemaName], false, undefined, ['x-ms-metadata', 'description', 'summary']);
        //     assert.deepStrictEqual(a, b);
        //   } catch (E) {
        //     console.error(E);
        //   }

        //   throw new Error(`Incompatible models conflicting: ${schemaName}`);

        // }
      }
    }
    return target;
  }

  protected visitParameter(parameter: ProxyObject<AnyObject>, originalNodes: Iterable<Node>) {
    for (const { key, value, pointer, children } of originalNodes) {
      switch (key) {
        case 'schema':
          if (value.$ref) {
            // parameter schemas have to be inlined because the imodeler1 can't handle them
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
          this.visitResponses(this.responses, children);
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

  // compose-a-vous!
  const composer = new NewComposer(inputs[0]);
  return new QuickDataSource([await sink.WriteObject('composed oai3 doc...', await composer.getOutput(), [].concat.apply([], inputs.map(each => each.identity) as any), 'merged-oai3', await composer.getSourceMappings())], input.skip);
}

/* @internal */
export function createNewComposerPlugin(): PipelinePlugin {
  return compose;
}
