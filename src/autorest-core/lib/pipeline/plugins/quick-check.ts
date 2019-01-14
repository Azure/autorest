import { AnyObject, DataHandle, DataSink, DataSource, Node, parseJsonPointer, Processor, QuickDataSource } from '@microsoft.azure/datastore';
import { items } from '@microsoft.azure/linq'
import { ConfigurationView } from '../../configuration';
import { PipelinePlugin } from '../common';
import { format } from 'path';

async function quickCheck(config: ConfigurationView, input: DataSource, sink: DataSink) {
  const inputs = await Promise.all((await input.Enum()).map(async x => input.ReadStrict(x)));
  for (const each of inputs) {
    const oai = each.ReadObject<AnyObject>();

    const models = new Map<string, string[]>();
    const enums = new Map<string, string[]>();
    // check to see if there are models with the same name
    for (const { key, value } of items(oai.components.schemas)) {
      const schema = <AnyObject>value;
      const name = value['x-ms-metadata'].name;

      if (schema.type === 'string' && schema.enum) {
        // it's an enum
        if (!enums.has(name)) {
          enums.set(name, []);
        }
        (enums.get(name) || []).push(key);
      }

      if (!schema.type || schema.type === 'object') {
        // it's a model
        if (!models.has(name)) {
          models.set(name, []);
        }
        (models.get(name) || []).push(key);
      }
    }
    let failed = false
    for (const { key, value } of items(models)) {
      if (value.length > 1) {
        //failed = true;
        console.error(`Model ${key} has multiple implementations: ${value.join(',')}`);
      }
    }
    console.error('--------------------------------------------------------------------');
    for (const { key, value } of items(enums)) {
      if (value.length > 1) {
        failed = true;
        console.error(`Enum ${key} has multiple implementations: ${value.join(',')}`);
      }
    }
    if (failed) {
      throw new Error("Detected Collisions.");
    }
  }



  const result: Array<DataHandle> = [];

  return new QuickDataSource(result, input.skip);
}

/* @internal */
export function createQuickCheckPlugin(): PipelinePlugin {
  return quickCheck;
}