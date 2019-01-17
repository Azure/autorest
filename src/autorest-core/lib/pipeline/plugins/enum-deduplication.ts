import { AnyObject, DataHandle, DataSink, DataSource, Node, visit, SimpleProcessor, QuickDataSource } from '@microsoft.azure/datastore';
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { Dictionary, items } from '@microsoft.azure/linq';
import * as compareVersions from 'compare-versions';


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


export class EnumDeduplicator extends SimpleProcessor {
  protected refs = new Map<string, Array<{ target: AnyObject, pointer: string }>>();
  protected enums = new Map<string, Array<{ target: AnyObject, value: AnyObject, key: string, pointer: string, originalNodes: Iterable<Node> }>>();
  async visitLeaf(target: AnyObject, value: AnyObject, key: string, pointer: string, originalNodes: Iterable<Node>) {
    //console.error(`Visit Leaf: ${pointer}`);

    if (pointer.startsWith('/components/schemas/') && value.enum) {
      // it's an enum 
      // let's handle this ourselves.
      const name = value['x-ms-metadata'].name;
      const e = this.enums.get(name) || this.enums.set(name, []).get(name) || [];
      e.push({ target, value, key, pointer, originalNodes });
      return true;
    }

    if (key === '$ref') {
      //console.error(`Deferring $ref at ${pointer}`);
      const ref = value.toString();
      // let's hold onto the $ref object until we're done.
      const r = this.refs.get(ref) || this.refs.set(ref, []).get(ref) || []
      r.push({ target, pointer });
      return true;
    }
    return false;
  }

  public async finish() {
    // time to consolodate the enums
    for (const { key: name, value } of items(this.enums)) {
      // first sort them according to api-version order
      const enumSet = value.sort((a, b) => compareVersions(getSemverEquivalent(getMaxApiVersion(a.value['x-ms-metadata'].apiVersions)), getSemverEquivalent(getMaxApiVersion(b.value['x-ms-metadata'].apiVersions))));

      const first = enumSet[0];
      if (enumSet.length === 1) {

        const originalRef = `#/components/schemas/${first.key}`;
        const newRef = `#/components/schemas/${name}`;

        // only one of this enum, we can just put it in without any processing
        // (switching the generic name out for the name of the enum.)
        this.clone(first.target, name, first.pointer, first.value);
        this.fixUp(originalRef, newRef, first.pointer);
        continue;
      }

      // otherwise, we need to take the different versions of the enum,
      // combine all the values into a single enum
      const mergedEnum = this.newObject(first.target, name, first.pointer);
      this.clone(mergedEnum, 'x-ms-metadata', first.pointer, first.value['x-ms-metadata']);
      this.clone(mergedEnum, 'description', first.pointer, first.value.description);
      this.clone(mergedEnum, 'x-ms-enum', first.pointer, first.value['x-ms-enum']);
      this.clone(mergedEnum, 'type', first.pointer, 'string');
      const newRef = `#/components/schemas/${name}`;
      this.newArray(mergedEnum, 'enum', '');

      for (const each of enumSet) {
        for (const e of each.value.enum) {
          if (mergedEnum.enum.indexOf(e) == -1) {
            mergedEnum.enum.__push__({ value: e, pointer: each.pointer });
          }
        }
        const originalRef = `#/components/schemas/${each.key}`;
        this.fixUp(originalRef, newRef, each.pointer);
      }
    }

    // write out the remaining unchanged $ref instances
    for (const { key: reference, value: refSet } of items(this.refs)) {
      for (const each of refSet) {
        this.clone(each.target, '$ref', each.pointer, reference);
      }
    }
  }

  fixUp(originalRef: string, newRef: string, pointer) {
    const fixups = this.refs.get(originalRef);
    if (fixups) {
      for (const each of fixups) {
        each.target.$ref = { value: newRef, pointer };
      }
    }
    this.refs.delete(originalRef);
  }
}

async function deduplicateEnums(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  const result: Array<DataHandle> = [];
  for (const each of inputs) {
    const ed = new EnumDeduplicator(each);
    result.push(await sink.WriteObject(each.Description, await ed.getOutput(), each.identity, each.artifactType, await ed.getSourceMappings()));
  }
  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createEnumDeduplicator(): PipelinePlugin {
  return deduplicateEnums;
}

