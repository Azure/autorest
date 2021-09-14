import { BlameTree, DataStore } from "@azure-tools/datastore";
import { LogInfo, EnhancedLogInfo, SourceLocation, EnhancedSourceLocation } from "./types";

export class LogSourceEnhancer {
  public constructor(private dataStore: DataStore) {}

  public async process(log: LogInfo): Promise<EnhancedLogInfo> {
    if (log.source === undefined) {
      return log as EnhancedLogInfo;
    }
    const sources = await this.resolveOriginalSources(log, log.source);
    return {
      ...log,
      source: this.resolveOriginalDocumentNames(sources),
    };
  }

  private async resolveOriginalSources(message: LogInfo, source: SourceLocation[]): Promise<EnhancedSourceLocation[]> {
    const blameSources = source.map(async (s) => {
      let blameTree: BlameTree | null = null;

      try {
        while (blameTree === null) {
          try {
            blameTree = await this.dataStore.blame(s.document, s.position);
          } catch (e) {
            console.error("CaTch ", e);
            if ("path" in s.position) {
              const path = s.position.path;
              if (path.length === 0) {
                throw e;
              }
              // adjustment
              // 1) skip leading `$`
              if (path[0] === "$") {
                path.shift();
              } else {
                path.pop();
              }
            } else {
              throw e;
            }
          }
        }
      } catch (e) {
        return [s];
      }

      return blameTree.getMappingLeafs().map((r) => ({
        document: r.source,
        position: { line: r.line, column: r.column },
      }));
    });

    return (await Promise.all(blameSources)).flat();
  }

  private resolveOriginalDocumentNames(sources: EnhancedSourceLocation[]): EnhancedSourceLocation[] {
    return sources.map((source) => {
      if (source.position) {
        try {
          const document = this.dataStore.readStrictSync(source.document).description;
          return { ...source, document };
        } catch {
          // no worries
        }
      }
      return source;
    });
  }
}
