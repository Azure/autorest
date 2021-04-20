import { QuickDataSource, DataHandle, AnyObject, selectNodes } from "@azure-tools/datastore";
import { createPerFilePlugin, PipelinePlugin } from "../../pipeline/common";
import { Manipulator } from "./manipulation";
import { Channel } from "../../message";
import { evalDirectiveTransform } from "./eval";
import { resolveDirectives } from "@autorest/configuration";

/* @internal */
export function createGraphTransformerPlugin(): PipelinePlugin {
  return async (context, input, sink) => {
    // object transforms must have a where clause and a transform
    const directives = resolveDirectives(
      context.config,
      (x) => x.from.length > 0 && x.transform.length > 0 && x.where.length > 0,
    ); // && (!!x.where && x.where.length > 0)

    const result: Array<DataHandle> = [];
    for (const file of await input.Enum()) {
      const inputHandle = await input.Read(file);
      if (inputHandle) {
        const documentId = `/${inputHandle.Description || inputHandle.key}`;
        let contents: AnyObject | undefined = undefined;
        let modified = false;

        for (const directive of directives) {
          if (
            directive.from.find(
              (each) =>
                each === inputHandle.artifactType || // artifact by type (ie, source-file-csharp)
                documentId.endsWith(`/${each}`) || // by name (ie, Get_AzAdSomething.cs)
                documentId.match(new RegExp(`/.+/${each}$`)),
            )
          ) {
            // by regex (ie, Get-AzAd.*.cs)

            for (const where of directive.where) {
              // if the file should be processed, run it thru
              for (const transform of directive.transform) {
                // get the whole document
                contents = contents === undefined ? await inputHandle.ReadObjectFast() : contents;

                // find the target nodes in the document
                const targets = selectNodes(contents, where);
                if (targets.length > 0) {
                  context.Message({
                    Channel: Channel.Debug,
                    Text: `Running object transform '${directive.from}/${directive.reason}' on ${inputHandle.key} `,
                  });

                  for (const { path, value, parent } of targets) {
                    const output = evalDirectiveTransform(transform, {
                      config: context,
                      value,
                      parent: parent,
                      doc: contents,
                      path: path,
                      documentPath: inputHandle.key,
                    });

                    parent[path.last] = output;

                    // assuming this for now.
                    modified = true;
                  }
                }
              }
            }
          }
        }

        if (modified) {
          result.push(
            await sink.WriteObject(inputHandle.Description, contents, inputHandle.identity, inputHandle.artifactType),
          );
        } else {
          result.push(await sink.Forward(inputHandle.Description, inputHandle));
        }
      }
    }
    return new QuickDataSource(result, input.pipeState);
  };
}

/* @internal */
export function createTextTransformerPlugin(): PipelinePlugin {
  // create a lightweight text transformer.
  return async (config, input, sink) => {
    // get directives as concrete objects.

    // text transforms are always 'where: $' or no where clause at all.
    const directives = config.resolveDirectives(
      (x) => x.transform.length > 0 && (x.where.length === 0 || (x.where.length === 1 && x.where[0] === "$")),
    );

    if (directives.length === 0) {
      return input;
    }

    const result: Array<DataHandle> = [];
    for (const file of await input.Enum()) {
      const inputHandle = await input.Read(file);
      if (inputHandle) {
        const documentId = `/${inputHandle.Description || inputHandle.key}`;
        let contents: string | undefined = undefined;
        let modified = false;

        for (const directive of directives) {
          if (
            directive.from.length === 0 ||
            directive.from.find(
              (each) =>
                each === inputHandle.artifactType || // artifact by type (ie, source-file-csharp)
                documentId.endsWith(`/${each}`) || // by name (ie, Get_AzAdSomething.cs)
                documentId.match(new RegExp(`/.+/${each}$`)),
            )
          ) {
            // by regex (ie, Get-AzAd.*.cs)

            // if the file should be processed, run it thru
            for (const transform of directive.transform) {
              // grab the contents (don't extend the cache tho')
              contents = contents === undefined ? await inputHandle.ReadData(true) : contents;

              config.Message({
                Channel: Channel.Debug,
                Text: `Running text transform '${directive.from}/${directive.reason}' on ${inputHandle.key} `,
              });

              const output = evalDirectiveTransform(transform, {
                config,
                value: contents,
                doc: inputHandle,
                path: [],
                documentPath: inputHandle.key,
              });

              if (typeof output !== "string") {
                throw new Error(
                  [
                    `Unexpected result from directive, expected a string but got '${typeof output}'.`,
                    "Transform code:\n",
                    directive.transform,
                  ].join("\n"),
                );
              }

              if (output !== contents) {
                modified = true;
                contents = output;
              }
            }
          }
        }

        if (modified) {
          result.push(
            await sink.WriteData(
              inputHandle.Description,
              contents || "",
              inputHandle.identity,
              inputHandle.artifactType,
            ),
          );
        } else {
          result.push(await sink.Forward(inputHandle.Description, inputHandle));
        }
      }
    }
    return new QuickDataSource(result, input.pipeState);
  };
}

/* @internal */
export function createTransformerPlugin(): PipelinePlugin {
  return createPerFilePlugin(async (config) => {
    const isObject = config.GetEntry("is-object") === false ? false : true;
    const manipulator = new Manipulator(config);
    return async (fileIn, sink) => {
      const fileOut = await manipulator.process(fileIn, sink, isObject, fileIn.Description);
      return sink.Forward(fileIn.Description, fileOut);
    };
  });
}

/* @internal */
export function createImmediateTransformerPlugin(): PipelinePlugin {
  return async (config, input, sink) => {
    const isObject = config.GetEntry("is-object") === false ? false : true;
    const files = await input.Enum(); // first all the immediate-configs, then a single swagger-document
    const scopes = await Promise.all(files.slice(0, files.length - 1).map((f) => input.ReadStrict(f)));
    const manipulator = new Manipulator(
      config.extendWith(...(await Promise.all(scopes.map((s) => s.ReadObject<any>())))),
    );
    const file = files[files.length - 1];
    const fileIn = await input.ReadStrict(file);
    const fileOut = await manipulator.process(fileIn, sink, isObject, fileIn.Description);
    return new QuickDataSource([await sink.Forward("swagger-document", fileOut)], input.pipeState);
  };
}
