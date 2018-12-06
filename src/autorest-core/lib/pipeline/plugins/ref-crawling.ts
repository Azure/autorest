import { AnyObject, DataHandle, DataSink, DataSource, Node, Processor, ProxyObject, ProxyNode, visit } from '@microsoft.azure/datastore';
import { ResolveUri } from '@microsoft.azure/uri';

export async function crawlReferences(inputScope: DataSource, filesToCrawl: Array<DataHandle>, sink: DataSink): Promise<Array<DataHandle>> {
  const result: Array<DataHandle> = [];
  let filesToExcludeInSearch: Array<string> = [];
  for (let i = 0; i < filesToCrawl.length; i++) {
    const fileUri = ResolveUri(filesToCrawl[i].originalDirectory, filesToCrawl[i].identity[0]);
    filesToExcludeInSearch.push(fileUri);
  }

  for (let i = 0; i < filesToCrawl.length; i++) {
    const currentSwagger = filesToCrawl[i];
    const refProcessor = new RefProcessor(currentSwagger, filesToExcludeInSearch);
    result.push(await sink.WriteObject(currentSwagger.Description, refProcessor.output, currentSwagger.identity, currentSwagger.artifactType, refProcessor.sourceMappings, [currentSwagger]));
    filesToExcludeInSearch = [...new Set([...filesToExcludeInSearch, ...refProcessor.newFilesFound])];
    for (let j = 0; j < refProcessor.newFilesFound.length; j++) {
      const originalSecondaryFile = await inputScope.ReadStrict(refProcessor.newFilesFound[j]);
      const fileMarker = new SecondaryFileMarker(originalSecondaryFile);
      filesToCrawl.push(await sink.WriteObject(originalSecondaryFile.Description, fileMarker.output, originalSecondaryFile.identity, originalSecondaryFile.artifactType, fileMarker.sourceMappings, [originalSecondaryFile]));
    }
  }
  return result;
}

class RefProcessor extends Processor<any, any> {

  public newFilesFound: Array<string> = new Array<string>();
  private originalFileLocation: string;
  private filesToExclude: Array<string>;

  constructor(originalFile: DataHandle, filesToExclude: Array<string>) {
    super(originalFile);
    this.originalFileLocation = ResolveUri(originalFile.originalDirectory, originalFile.identity[0]);
    this.filesToExclude = filesToExclude;
  }

  process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === '$ref') {
        const refFileName = (value.indexOf('#') === -1) ? value : value.split('#')[0];
        const refPointer = (value.indexOf('#') === -1) ? undefined : value.split('#')[1];
        const newRefFileName = ResolveUri(this.originalFileLocation, refFileName);
        const newReference = (refPointer) ? `${newRefFileName}#${refPointer}` : newRefFileName;
        if (!this.filesToExclude.includes(newRefFileName)) {
          this.newFilesFound.push(newRefFileName);
          this.filesToExclude.push(newRefFileName);
        }
        this.clone(targetParent, key, pointer, newReference);
      } else if (Array.isArray(value)) {
        this.process(this.newArray(targetParent, key, pointer), children);
      } else if (value && typeof (value) === 'object') {
        this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        this.clone(targetParent, key, pointer, value);
      }
    }
  }
}

class SecondaryFileMarker extends Processor<any, any> {

  process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
      if (!targetParent['x-ms-secondary-file']) {
        targetParent['x-ms-secondary-file'] = { value: true, pointer, filename: this.key };
      }
    }
  }
}
