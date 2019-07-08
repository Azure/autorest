import { AnyObject, DataHandle, DataSink, DataSource, Node, Transformer, ProxyObject, ProxyNode, visit } from '@microsoft.azure/datastore';
import { ResolveUri } from '@microsoft.azure/uri';

export async function crawlReferences(inputScope: DataSource, filesToCrawl: Array<DataHandle>, sink: DataSink): Promise<Array<DataHandle>> {
  const result: Array<DataHandle> = [];
  let filesToExcludeInSearch: Array<string> = [];
  for (const file of filesToCrawl) {
    const fileUri = ResolveUri(file.originalDirectory, file.identity[0]);
    filesToExcludeInSearch.push(fileUri);
  }

  for (const currentSwagger of filesToCrawl) {
    const refProcessor = new RefProcessor(currentSwagger, filesToExcludeInSearch, inputScope);
    result.push(await sink.WriteObject(currentSwagger.Description, await refProcessor.getOutput(), currentSwagger.identity, currentSwagger.artifactType, await refProcessor.getSourceMappings(), [currentSwagger]));
    filesToExcludeInSearch = [...new Set([...filesToExcludeInSearch, ...refProcessor.newFilesFound])];
    for (const fileUri of refProcessor.newFilesFound) {
      const originalSecondaryFile = await inputScope.ReadStrict(fileUri);
      const fileMarker = new SecondaryFileMarker(originalSecondaryFile);
      const fileMarkerOutput = await fileMarker.getOutput();

      // When a new file is read, by default it has artifactType as 'input-file'. Transforms target specific types of artifacts;
      // for this reason we need to identify the artifact type, so transforms are applied to all docs, including SECONDARY-FILES.
      // Primary files at this point already have a proper artifactType.
      const artifactType = fileMarkerOutput.swagger ? 'swagger-document' : fileMarkerOutput.openapi ? 'openapi-document' : currentSwagger.artifactType;
      filesToCrawl.push(await sink.WriteObject(originalSecondaryFile.Description, fileMarkerOutput, originalSecondaryFile.identity, artifactType, await fileMarker.getSourceMappings(), [originalSecondaryFile]));
    }
  }

  return result;
}

class RefProcessor extends Transformer<any, any> {

  public newFilesFound: Array<string> = new Array<string>();
  private originalFileLocation: string;
  private filesToExclude: Array<string>;

  constructor(originalFile: DataHandle, filesToExclude: Array<string>, private inputScope: DataSource) {
    super(originalFile);
    this.originalFileLocation = ResolveUri(originalFile.originalDirectory, originalFile.identity[0]);
    this.filesToExclude = filesToExclude;
  }

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === 'x-ms-examples') {
        continue;
      }
      if (key === '$ref') {
        const refFileName = (value.indexOf('#') === -1) ? value : value.split('#')[0];
        const refPointer = (value.indexOf('#') === -1) ? undefined : value.split('#')[1];
        const newRefFileName = ResolveUri(this.originalFileLocation, refFileName);

        if (!refPointer) {
          // inline the whole file
          const handle = await this.inputScope.ReadStrict(newRefFileName);
          // todo: we should probably build a source map for the pulled in file, but
          // I'm not going to do that today.
          //targetParent[key] = { value: handle.ReadObject<AnyObject>(), pointer };
          continue;
        }

        const newReference = (refPointer) ? `${newRefFileName}#${refPointer}` : newRefFileName;

        if (!this.filesToExclude.includes(newRefFileName)) {

          this.newFilesFound.push(newRefFileName);
          this.filesToExclude.push(newRefFileName);
        }
        this.clone(targetParent, key, pointer, newReference);
      } else if (Array.isArray(value)) {
        await this.process(this.newArray(targetParent, key, pointer), children);
      } else if (value && typeof (value) === 'object') {
        await this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        this.clone(targetParent, key, pointer, value);
      }
    }
  }
}

class SecondaryFileMarker extends Transformer<any, any> {

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer } of originalNodes) {
      this.clone(targetParent, key, pointer, value);
      if (!targetParent['x-ms-secondary-file']) {
        targetParent['x-ms-secondary-file'] = { value: true, pointer, filename: this.currentInputFilename };
      }
    }
  }
}
