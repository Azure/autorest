import { DataHandle, DataSink, DataSource } from "@azure-tools/datastore";
import { parseJsonRef } from "@azure-tools/jsonschema";
import { resolveUri } from "@azure-tools/uri";
import { AutorestContext } from "../../context";

export async function loadAllReferencedFiles(
  context: AutorestContext,
  inputScope: DataSource,
  filesToCrawl: Array<DataHandle>,
  sink: DataSink,
): Promise<DataHandle[]> {
  // primary files should be in the order they were referenced; the order of the operations can affect the order
  // that API classes are generated in.
  const primary: DataHandle[] = [];

  // secondary files shouldn't matter (since we don't process their operations)
  const secondary: DataHandle[] = [];

  // files that have been queued up to resolve references
  const queued = new Set<string>();

  /** crawls a file for $refs and then recurses to get the $ref'd files */
  async function crawl(file: DataHandle) {
    const uri = resolveUri(file.originalDirectory, file.identity[0]);
    const filesReferenced = findReferencedFiles(uri, await file.readObject());
    for (const fileUri of filesReferenced.filter((each) => !queued.has(each))) {
      queued.add(fileUri);

      context.verbose(`Reading $ref'd file ${fileUri}`);
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
        { pathMappings: [] },
      );

      // crawl that and add it to the secondary set.
      secondary.push(await crawl(next));
    }

    return sink.forward(file.description, file);
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

function findReferencedFiles(originalFileLocation: string, spec: any): string[] {
  const filesReferenced = new Set<string>();

  function visit(obj: any) {
    for (const [key, value] of Object.entries(obj)) {
      // We don't want to navigate the examples.
      if (key === "x-ms-examples") {
        continue;
      }
      if (key === "$ref" && typeof value === "string") {
        const { file, path } = parseJsonRef(value);

        if (!path) {
          // points to a whole file? Huh?
          continue;
        }
        const newRefFileName = resolveUri(originalFileLocation, file ?? "");

        filesReferenced.add(newRefFileName);
      } else if (Array.isArray(value)) {
        visit(value);
      } else if (value && typeof value === "object") {
        visit(value);
      }
    }
  }

  visit(spec);
  return [...filesReferenced];
}
