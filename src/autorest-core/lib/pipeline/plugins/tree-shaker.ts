import { AnyObject, DataHandle, DataSink, DataSource, Node, parseJsonPointer, Transformer, QuickDataSource, JsonPath, Source } from '@microsoft.azure/datastore';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { clone } from '@microsoft.azure/linq';
import { values } from '@microsoft.azure/codegen';

const methods = new Set([
  'get',
  'put',
  'post',
  'delete',
  'options',
  'head',
  'patch',
  'trace'
]);
export class OAI3Shaker extends Transformer<AnyObject, AnyObject> {

  constructor(originalFile: Source, private isSimpleTreeShake: boolean) {
    super([originalFile]);
  }

  private docServers?: Array<AnyObject>;
  private pathServers?: Array<AnyObject>;
  private operationServers?: Array<AnyObject>;

  get servers() {
    // it's not really clear according to OAI3 spec, but I'm going to assume that
    // a servers entry at a given level, replaces a servers entry at an earlier level.
    return this.operationServers || this.pathServers || this.docServers || [];
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
    // split out servers first.
    const [servers, theNodes] = values(originalNodes).linq.bifurcate(each => each.key === 'servers');

    // set the doc servers
    servers.forEach(s => this.docServers = s.value);

    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of theNodes) {
      switch (key) {
        case 'paths':
          this.visitPaths(this.newObject(targetParent, key, pointer), children);
          break;

        case 'components':
          this.visitComponents(this.components, children);
          break;

        case 'x-ms-metadata':
        case 'x-ms-secondary-file':
        case 'info':
          this.clone(targetParent, key, pointer, value);
          break;

        // copy these over without worrying about moving things down to components.
        default:
          if (!this.current['x-ms-secondary-file']) {
            this.clone(targetParent, key, pointer, value);
          }
          break;
      }
    }

    if (this.docServers !== undefined) {
      this.clone(targetParent, 'servers', '/servers', this.docServers);
    }
  }

  visitPaths(targetParent: AnyObject, nodes: Iterable<Node>) {
    for (const { key, pointer, children } of nodes) {
      // each path
      this.visitPath(this.newObject(targetParent, key, pointer), children);
    }
  }

  visitPath(targetParent: AnyObject, nodes: Iterable<Node>) {
    // split out the servers first.
    const [servers, theNodes] = values(nodes).linq.bifurcate(each => each.key === 'servers');

    // set the operationServers if they exist.
    servers.forEach(s => this.pathServers = s.value);

    // handle the rest.
    for (const { value, key, pointer, children } of theNodes) {
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

    // reset at end
    this.pathServers = undefined;
  }

  visitHttpOperation(targetParent: AnyObject, nodes: Iterable<Node>) {

    // split out the servers first.
    const [servers, theNodes] = values(nodes).linq.bifurcate(each => each.key === 'servers');

    // set the operationServers if they exist.
    servers.forEach(s => this.operationServers = s.value);

    this.clone(targetParent, "servers", '/', this.servers);

    for (const { value, key, pointer, children } of theNodes) {
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

    // reset at end
    this.operationServers = undefined;

  }

  visitParameter(targetParent: AnyObject, nodes: Iterable<Node>) {
    const [requiredNodes, theOtherNodes] = values(nodes).linq.bifurcate(each => each.key === 'required');
    const isRequired = (requiredNodes.length > 0) ? !!requiredNodes[0].value : false;
    for (const { value, key, pointer, children } of theOtherNodes) {
      switch (key) {
        case 'schema':
          if (isRequired && value.enum && value.enum.length === 1) {
            // if an enum has a single value and it is required, then it's just a constant. Thus, not necessary to shake it.
            this.clone(targetParent, key, pointer, value);
            break;
          }
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

    if (requiredNodes[0] !== undefined) {
      this.clone(targetParent, requiredNodes[0].key, requiredNodes[0].pointer, requiredNodes[0].value);
    }
  }

  visitSchema(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    const object = 'object';
    const [requiredField, theNodes] = values(originalNodes).linq.bifurcate(each => each.key === 'required');
    const requiredProperties = new Array<string>();
    if (requiredField[0] !== undefined) {
      requiredProperties.push(...requiredField[0].value);
    }

    for (const { value, key, pointer, children } of theNodes) {
      switch (key) {
        case 'anyOf':
        case 'oneOf':
          // an array of schemas to dereference
          this.dereferenceItems(`/components/schemas`, this.schemas, this.visitSchema, this.newArray(targetParent, key, pointer), children);
          break;

        case 'properties':
          this.visitProperties(this.newObject(targetParent, key, pointer), children, requiredProperties);
          break;

        case 'additionalProperties':
          if (typeof value === object) {
            // it should be a schema
            this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children);
          } else {
            // otherwise, just copy it across.
            this.clone(targetParent, key, pointer, value);
          }
          break;

        case 'allOf':
          // an array of schemas to dereference
          // this is a fix to the bad practice of putting the actual properties of the model inside one of the allOf's
          // Without this, the generator would create superClasses with 'random names' (not exactly random, they would be unique by the tree-shaking procedure)
          // to derive the current class from. 
          const allOf = this.newArray(targetParent, key, pointer);
          for (const { value: allOfItemVal, children: allOfItemChildren, pointer: allOfItemPointer, key: allOfItemKey } of children) {
            this.dereference(`/components/schemas`, this.schemas, this.visitSchema, allOf, allOfItemKey, allOfItemPointer, allOfItemVal, allOfItemChildren);
          }
          break;

        case 'not':
        case 'items':
          this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children, `${this.getNameHint(pointer)}Item`);
          break;

        // everything else, just copy recursively.
        default:
          if (targetParent[key] && targetParent[key] === value) {
            // properties that are already there and the same...
            break;
          }
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }

    if (requiredProperties.length > 0) {
      this.clone(targetParent, requiredField[0].key, requiredField[0].pointer, requiredProperties);
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

  visitArrayProperty(targetParent: AnyObject, key: string, pointer: string, value: AnyObject, children: Iterable<Node>, nameHint: string) {
    if (value.items.type === 'boolean' || value.items.type === 'integer' || value.items.type === 'number') {
      this.clone(targetParent, key, pointer, value);
    } else {
      // object or string
      this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children, nameHint);
    }
  }

  getNameHint(pointer: string): string {
    const getArrayItemPropertyNameHint = (jp: JsonPath) => {
      // a unique id using the path, skipping 'properties'
      // and converting the 'items' to 'item'.
      let nameHint = '';
      for (let i = 2; i < jp.length; i += 1) {
        if (jp[i] === 'properties') {
          continue;
        }

        const part = (jp[i] === 'items') ? 'item' : jp[i];
        nameHint += (i === 2) ? `${part}` : `-${part}`;
      }
      return nameHint;
    };

    const getPropertyNameHint = (jp: JsonPath) => {
      let nameHint = '';
      for (let i = 2; i < jp.length; i += 2) {
        nameHint += (i === 2) ? `${jp[i]}` : `-${jp[i]}`;
      }
      return nameHint;
    };

    const jsonPath = parseJsonPointer(pointer);
    return (jsonPath[jsonPath.length - 3] === 'items') ? getArrayItemPropertyNameHint(jsonPath) : getPropertyNameHint(jsonPath);
  }

  visitProperties(targetParent: AnyObject, originalNodes: Iterable<Node>, requiredProperties: Array<string>) {
    for (const { value, key, pointer, children } of originalNodes) {
      // if the property has a schema that type 'boolean', 'integer', 'number' then we'll just leave it inline
      // we will leave strings inlined only if they ask for simple-tree-shake. Also, if it's a string + enum + required + single val enum
      // reason: old modeler does not handle non-inlined string properties.
      switch (value.type) {
        case 'string':
          if (this.isSimpleTreeShake && !value.enum) {
            this.clone(targetParent, key, pointer, value);
          } else if (value.enum !== undefined && value.enum.length === 1 && requiredProperties.includes(key)) {
            // this is basically a constant, so no need to shake.
            this.clone(targetParent, key, pointer, value);
          } else {
            const nameHint = this.getNameHint(pointer);
            this.dereference(`/components/schemas`, this.schemas, this.visitSchema, targetParent, key, pointer, value, children, nameHint);
          }
          break;
        case 'boolean':
        case 'integer':
        case 'number':
          this.clone(targetParent, key, pointer, value);
          break;
        case 'array':
          if (this.isSimpleTreeShake) {
            this.clone(targetParent, key, pointer, value);
          } else {
            this.visitArrayProperty(targetParent, key, pointer, value, children, this.getNameHint(pointer));
          }

          break;
        default:
          // inline objects had a name of '<Class><PropertyName>'
          // the dereference method will use the full path to build a name, and we should ask it to use the same thing that
          // we were using before..
          const nameHint = this.getNameHint(pointer);
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
    if (nameHint) {
      // fix namehint to not have unexpected characters.
      nameHint = nameHint.replace(/[\/\\]+/g, '-');
      if (targetCollection[nameHint]) {
        nameHint = undefined;
      }
    }

    const id = nameHint || `${parseJsonPointer(pointer).map(each => `${each}`.toLowerCase().replace(/-+/g, '_').replace(/\W+/g, '-').split('-').filter(each => each).join('-')).filter(each => each).join('·')}`.replace(/\·+/g, '·');

    // set the current location's object to be a $ref
    targetParent[key] = {
      value: {
        $ref: `#${baseReferencePath}/${id}`,
        description: value.description,  // we violate spec to allow a unique description at the $ref spot, (ie: there are two fields that are of type 'color' -- one is 'borderColor' and one is 'fillColor' -- may be differen descriptions.)
        readOnly: value.readOnly
      }, pointer
    };

    // Q: I removed the 'targetCollection[key] ||' from this before. Why did I do that?
    // const tc = targetCollection[key] || this.newObject(targetCollection, id, pointer);
    const tc = targetCollection[id] || this.newObject(targetCollection, id, pointer);

    // copy the parts of the parameter across
    visitor.bind(this)(tc, children);
    return tc;
  }
}

async function shakeTree(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  const isSimpleTreeShake = !!config.GetEntry('simple-tree-shake');
  for (const each of inputs) {
    const shaker = new OAI3Shaker(each, isSimpleTreeShake);
    result.push(await sink.WriteObject('tree shaken doc...', await shaker.getOutput(), each.identity, 'tree-shaken-oai3', await shaker.getSourceMappings()));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createTreeShakerPlugin(): PipelinePlugin {
  return shakeTree;
}
