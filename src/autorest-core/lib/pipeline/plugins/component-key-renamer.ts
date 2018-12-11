import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, QuickDataSource, visit } from '@microsoft.azure/datastore';
import { clone, Dictionary } from '@microsoft.azure/linq';
import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';

export class ComponentKeyRenamer extends Processor<any, oai.Model> {
  // oldRefs -> newRefs;
  newRefs = new Dictionary<string>();

  public process(targetParent: ProxyObject<oai.Model>, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'components':
          const components = <oai.Components>targetParent.components || this.newObject(targetParent, 'components', pointer);
          this.visitComponents(components, children);
          break;

        // copy these over without worrying about moving things down to components.
        default:
          this.clone(targetParent, key, pointer, value);
          break;
      }
    }
  }

  visitComponents(components: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      switch (key) {
        case 'schemas':
        case 'responses':
        case 'parameters':
        case 'examples':
        case 'requestBodies':
        case 'headers':
        case 'securitySchemes':
        case 'links':
        case 'callbacks':
          if (components[key] === undefined) {
            this.newObject(components, key, pointer);
          }
          this.visitComponent(key, components[key], children);
          break;

        // everything else, just copy recursively.
        default:
          this.clone(components, key, pointer, value);
          break;
      }
    }
  }

  visitComponent<T>(type: string, container: ProxyObject<Dictionary<T>>, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      const name = value['x-ms-metadata'].name;
      this.newRefs[`#/components/${type}/${key}`] = `#/components/${type}/${name}`;
      this.clone(container, name, pointer, value);
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
          const newRef = this.newRefs[ref];
          if (newRef) {
            value.$ref = newRef;
          }
        }
        // now, recurse into this object
        this.updateRefs(value);
      }
    }
  }
}

async function renameComponentsKeys(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const processor = new ComponentKeyRenamer(each);
    result.push(await sink.WriteObject('oai3-component-renamed doc...', processor.output, each.identity, 'oi3-component-renamed', processor.sourceMappings));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createComponentKeyRenamerPlugin(): PipelinePlugin {
  return renameComponentsKeys;
}
