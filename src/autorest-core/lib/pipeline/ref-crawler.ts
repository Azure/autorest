import { DataHandle, DataSink, DataSource, JsonPath, JsonPointer, Node, Processor, QuickDataSource, visit, walk, AnyObject } from '@microsoft.azure/datastore';
import * as oai from '@microsoft.azure/openapi';
import { ConfigurationView } from '../configuration';
import { PipelinePlugin } from './common';


export class RefCrawler extends Processor<AnyObject, AnyObject> {

  public filesFound: Array<string> = new Array<string>();

  process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    // initialize certain things ahead of time:
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === '$ref') {
        const newFileName = "newFileName.json";
        this.filesFound.push(newFileName);
        targetParent[key] = { value: newFileName, pointer };
      } else if (Array.isArray(value)) {
        this.process(this.newArray(targetParent, key, pointer), children);
      } else if (typeof (value) === 'object') {
        this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        targetParent[key] = { value, pointer };
      }
    }
  }
}