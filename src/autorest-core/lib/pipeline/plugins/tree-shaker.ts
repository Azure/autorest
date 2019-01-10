import { AnyObject, DataHandle, DataSink, DataSource, Node, parseJsonPointer, Processor, QuickDataSource } from '@microsoft.azure/datastore';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

export class OAI3Shaker extends Processor<AnyObject, AnyObject> {
  get components(): AnyObject {
    if (this.generated.components) {
      return this.generated.components;
    }
    if (this.current.components) {
      return this.newObject(this.generated, 'components', '/components');
    }
    return this.newObject(this.generated, 'components', '/');
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

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'paths':
          this.visitPaths(this.newObject(targetParent, key, pointer), children);
          break;

        case 'components':
          this.visitComponents(this.components, children);
          break;

        // copy these over without worrying about moving things down to components.
        default:
          if (!this.current['x-ms-secondary-file']) {
            this.clone(targetParent, key, pointer, value);
          }
          break;
      }
    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {

    for (const { key, pointer, children } of nodes) {
      // each path
      this.visitPath(this.newObject(targetParent, key, pointer), children);
    }
  }

  visitPath(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of nodes) {
      switch (key) {

        case 'get':
        case 'put':
        case 'post':
        case 'delete':
        case 'options':
        case 'head':
        case 'patch':
        case 'trace':
          this.visitHttpOperation(this.newObject(targetParent, key, pointer), children);
          break;

        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitHttpOperation(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of nodes) {
      switch (key) {
        case 'parameters':
          // parameters are a small special case, because they have to be tweaked when they are moved to the global parameter section.
          const newArray = this.newArray(targetParent, key, pointer);
          for (const child of children) {
            const p = this.dereference('/components/parameters', this.parameters, this.visitParameter, newArray, child.key, child.pointer, child.value, child.children);
            // tag it as a method parameter. (default is 'client', so we have to tag it when we move it.)
            if (p['x-ms-parameter-location'] === undefined) {
              p['x-ms-parameter-location'] = { value: 'method', pointer: '' };
            }
          }
          break;

        case 'requestbody':
          this.dereference(`/components/requestBodies`, this.requestBodies, this.visitRequestBody, targetParent, key, pointer, value, children);
          break;
        case 'responses':
          this.dereferenceItems(`/components/responses`, this.responses, this.visitResponse, this.newObject(targetParent, key, pointer), children);
          break;
        case 'callbacks':
          this.dereferenceItems(`/components/callbacks`, this.callbacks, this.visitCallback, this.newObject(targetParent, key, pointer), children);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitParameter(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of nodes) {
      switch (key) {
        case 'schema':
          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          break;
        case 'content':
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitSchema(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {

        case 'anyOf':
        case 'allOf':
        case 'oneOf':
          // an array of schemas to dereference
          this.dereferenceItems(`/components/schemas`, this.schemas, this.visitSchema, this.newArray(targetParent, key, pointer), children);
          break;

        case 'properties':
          this.visitProperties(this.newObject(targetParent, key, pointer), children);
          break;

        case 'additionalProperties':
          if (typeof value === 'object') {
            // it should be a schema
            this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          } else {
            // otherwise, just copy it across.
            this.clone(targetParent, key, pointer, value);
          }
          break;

        case 'not':
        case 'items':
          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitContent(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, pointer, children } of originalNodes) {
      this.visitMediaType(this.newObject(targetParent, key, pointer), children);
    }
  }

  visitMediaType(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'schema':
          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitProperties(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      // if the property has a schema that type 'string', 'boolean', 'integer', 'number' then we'll just leave it inline
      switch (value.type) {
        case 'string':
        case 'boolean':
        case 'integer':
        case 'number':
        case 'array':
          this.clone(targetParent, key, pointer, value);
          break;

        default:
          // inline objects had a name of '<Class><PropertyName>'
          // the dereference method will use the full path to build a name, and we should ask it to use the same thing that
          // we were using before..
          const pc = parseJsonPointer(pointer);
          const nameHint = `${pc[pc.length - 3]} ${pc[pc.length - 1]}`;

          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children, nameHint);
          break;
      }

    }
  }

  visitRequestBody(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        // everything else, just copy recursively.
        case 'content':
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  dereferenceItems(baseReferencePath: string, targetCollection: any, visitor: (tp: any, on: Iterable<Node>) => void, targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      this.dereference(baseReferencePath, targetCollection, visitor, targetParent, key, pointer, value, children);
    }
  }

  visitComponents(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'schemas':
          this.dereferenceItems(`/components/${key}`, this.schemas, this.visitSchema, this.schemas, children);
          break;

        case 'responses':
          this.dereferenceItems(`/components/${key}`, this.responses, this.visitResponse, this.responses, children);
          break;

        case 'parameters':
          this.dereferenceItems(`/components/${key}`, this.parameters, this.visitParameter, this.parameters, children);
          break;

        case 'examples':
          this.dereferenceItems(`/components/${key}`, this.examples, this.visitExample, this.examples, children);
          break;

        case 'requestBodies':
          this.dereferenceItems(`/components/${key}`, this.requestBodies, this.visitRequestBody, this.requestBodies, children);
          break;

        case 'headers':
          this.dereferenceItems(`/components/${key}`, this.headers, this.visitHeader, this.headers, children);
          break;

        case 'securitySchemes':
          this.dereferenceItems(`/components/${key}`, this.securitySchemes, this.visitSecurityScheme, this.securitySchemes, children);
          break;

        case 'links':
          this.dereferenceItems(`/components/${key}`, this.links, this.visitLink, this.links, children);
          break;

        case 'callbacks':
          this.dereferenceItems(`/components/${key}`, this.callbacks, this.visitCallback, this.callbacks, children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitResponse(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'content':
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        case 'headers':
          this.dereferenceItems(`/components/${key}`, this.headers, this.visitHeader, this.newObject(targetParent, key, pointer), children);
          break;
        case 'links':
          this.dereferenceItems(`/components/${key}`, this.links, this.visitLink, this.newObject(targetParent, key, pointer), children);
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitExample(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitHeader(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'schema':
          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          break;
        case 'content':
          this.visitContent(this.newObject(targetParent, key, pointer), children);
          break;
        // everything else, just copy recursively.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitSecurityScheme(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitLink(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
    }
  }

  visitCallback(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { key, pointer, children } of originalNodes) {
      this.visitPath(this.newObject(targetParent, key, pointer), children);
    }
  }

  dereference(baseReferencePath: string, targetCollection: AnyObject, visitor: (tp: any, on: Iterable<Node>) => void, targetParent: AnyObject, key: string, pointer: string, value: any, children: Iterable<Node>, nameHint?: string) {
    if (value.$ref) {
      // it's a reference already.
      return this.clone(targetParent, key, pointer, value);
    }

    if (targetParent === targetCollection) {
      const obj = this.newObject(targetParent, key, pointer);
      // it's actually in the right spot already.
      visitor.bind(this)(obj, children);
      return obj;
    }

    // not a reference, move the item

    // generate a unique id for the shaken item.
    const id = nameHint || `${parseJsonPointer(pointer).map(each => `${each}`.toLowerCase().replace(/\W+/g, '-').split('-').filter(each => each).join('-')).filter(each => each).join('·')}`.replace(/\·+/g, '·');

    // set the current location's object to be a $ref
    targetParent[key] = {
      value: {
        $ref: `#${baseReferencePath}/${id}`,
        description: value.description,  // we violate spec to allow a unique description at the $ref spot, (ie: there are two fields that are of type 'color' -- one is 'borderColor' and one is 'fillColor' -- may be differen descriptions.)
        readOnly: value.readOnly
      }, pointer
    };

    // const tc = targetCollection[key] || this.newObject(targetCollection, id, pointer);
    const tc = this.newObject(targetCollection, id, pointer);

    // copy the parts of the parameter across
    visitor.bind(this)(tc, children);
    return tc;
  }
}

async function shakeTree(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const shaker = new OAI3Shaker(each);
    result.push(await sink.WriteObject(each.Description, await shaker.getOutput(), each.identity, each.artifactType, await shaker.getSourceMappings()));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createTreeShakerPlugin(): PipelinePlugin {
  return shakeTree;
}
