import { AnyObject, DataHandle, DataSink, DataSource, Node, Transformer, visit } from "@azure-tools/datastore";
import { resolveUri } from "@azure-tools/uri";
import { AutorestContext } from "../context";
import { Channel } from "../message";
import { values, items, length } from "@azure-tools/linq";

export async function crawlReferences(
  config: AutorestContext,
  inputScope: DataSource,
  filesToCrawl: Array<DataHandle>,
  sink: DataSink,
): Promise<Array<DataHandle>> {
  // primary files should be in the order they were referenced; the order of the operations can affect the order
  // that API classes are generated in.
  const primary: Array<DataHandle> = [];

  // secondary files shouldn't matter (since we don't process their operations)
  const secondary: Array<DataHandle> = [];

  // files that have been queued up to resolve references
  const queued = new Set<string>();

  /** crawls a file for $refs and then recurses to get the $ref'd files */
  async function crawl(file: DataHandle) {
    const refProcessor = new RefProcessor(file, inputScope);
    const output = await refProcessor.getOutput();

    for (const fileUri of values(refProcessor.filesReferenced).where((each) => !queued.has(each))) {
      queued.add(fileUri);

      config.Message({ Channel: Channel.Verbose, Text: `Reading $ref'd file ${fileUri}` });
      const secondaryFile = await inputScope.readStrict(fileUri);

      // mark secondary files with a tag so that we don't process operations for them.
      const secondaryFileContent = await secondaryFile.readObject<any>();
      secondaryFileContent["x-ms-secondary-file"] = true;

      // When a new file is read, by default it has artifactType as 'input-file'. Transforms target specific types of artifacts;
      // for this reason we need to identify the artifact type, so transforms are applied to all docs, including SECONDARY-FILES.
      // Primary files at this point already have a proper artifactType.
      const next = await sink.writeObject(
        secondaryFile.description,
        secondaryFileContent,
        secondaryFile.identity,
        secondaryFileContent.swagger
          ? "swagger-document"
          : secondaryFileContent.openapi
          ? "openapi-document"
          : file.artifactType,
        [],
        [secondaryFile],
      );

      // crawl that and add it to the secondary set.
      secondary.push(await crawl(next));
    }

    // wait for all the x-ms-examples to finish getting resolved
    await Promise.all(refProcessor.promises);
    const mapping = await refProcessor.getSourceMappings();
    // write the file to the data sink (this serializes the file, so it has to be done by this point.)
    return sink.writeObject(file.description, output, file.identity, file.artifactType, mapping, [file]);
  }

  // this seems a bit convoluted, but in order to not break the order that
  // operations are generated in for existing generators
  // the order of the files (at least the *primary* files)
  // has to be preserved.
  await Promise.all(
    filesToCrawl.map(async (each, i) => {
      queued.add(resolveUri(each.originalDirectory, each.identity[0]));
      primary[i] = await crawl(each);
    }),
  );

  // return the finished files in the order they came (and then the secondary ones draggin' after.)
  return [...primary, ...secondary];
}

class RefProcessor extends Transformer<any, any> {
  public promises = new Array<Promise<void>>();
  public filesReferenced = new Set<string>();
  private originalFileLocation: string;

  constructor(originalFile: DataHandle, private inputScope: DataSource) {
    super(originalFile);

    this.originalFileLocation = resolveUri(originalFile.originalDirectory, originalFile.identity[0]);
  }

  async processXMSExamples(targetParent: AnyObject, examples: AnyObject) {
    const xmsExamples: any = {};

    for (const { key, value } of items(examples)) {
      if (value.$ref) {
        try {
          const refPath = value.$ref.indexOf("#") === -1 ? value.$ref : value.$ref.split("#")[0];
          const refUri = resolveUri(this.originalFileLocation, refPath);
          const handle = await this.inputScope.readStrict(refUri);
          xmsExamples[key] = await handle.readObject<AnyObject>();
        } catch {
          // skip examples that are not nice to us.
        }
      } else {
        // copy whatever was there I guess.
        xmsExamples[key] = value;
      }
    }

    if (length(xmsExamples) > 0) {
      targetParent["x-ms-examples"] = { value: xmsExamples, pointer: "" };
    }
  }

  async process(targetParent: AnyObject, originalNodes: Iterable<Node>) {
    for (const { value, key, pointer, children } of originalNodes) {
      if (key === "x-ms-examples") {
        // try to pull in the examples and insert them directly into this file.
        this.promises.push(this.processXMSExamples(targetParent, value));
        continue;
      }
      // If the key is $ref and the value is a string then it should be a json reference. Otherwise it might be a property called $ref if it is another type.
      if (key === "$ref" && typeof value === "string") {
        const refFileName = value.indexOf("#") === -1 ? value : value.split("#")[0];
        const refPointer = value.indexOf("#") === -1 ? undefined : value.split("#")[1];
        const newRefFileName = resolveUri(this.originalFileLocation, refFileName);

        if (!refPointer) {
          // points to a whole file? Huh?
          continue;
        }

        const newReference = refPointer ? `${newRefFileName}#${refPointer}` : newRefFileName;
        this.filesReferenced.add(newRefFileName);

        this.clone(targetParent, key, pointer, newReference);
      } else if (Array.isArray(value)) {
        await this.process(this.newArray(targetParent, key, pointer), children);
      } else if (value && typeof value === "object") {
        await this.process(this.newObject(targetParent, key, pointer), children);
      } else {
        this.clone(targetParent, key, pointer, value);
      }
    }
  }

  // we're overriding this because the part that processes x-ms-examples is designed
  // to do so asynchronously, and we can't clone the ouptut model because it's
  // technically not finished yet.
  // (we await the promises above, so it's finished when we go to use it. )
  protected async runProcess() {
    if (!this.final) {
      await this.init();
      for (this.currentInput of values(this.inputs)) {
        this.current = await this.currentInput.ReadObject<any>();
        await this.process(this.generated, visit(this.current));
      }
      await this.finish();
    }
    // changed from parent:
    // don't use clone in this case, because it's still working.
    this.final = this.generated;
  }
}
