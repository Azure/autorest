/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import { OperationCanceledException, Delay, LazyPromise, Lazy } from '@azure-tools/tasks';
import { ReadUri, ResolveUri, ParentFolderUri } from '@azure-tools/uri';
import { MappedPosition, MappingItem, Position, RawSourceMap, SourceMapConsumer, SourceMapGenerator } from 'source-map';
import { CancellationToken } from '../cancellation';
import { IFileSystem } from '../file-system';
import { FastStringify, ParseNode, ParseToAst as parseAst, YAMLNode, parseYaml } from '../yaml';
import { BlameTree } from '../source-map/blaming';
import { Compile, CompilePosition, Mapping, SmartPosition } from '../source-map/source-map';
import { promises as fs } from 'fs';
import { tmpdir } from 'os';
import { join } from 'path';

import { createHash } from 'crypto';
import { LineIndices } from '../main';
const md5 = (content: any) => content ? createHash('md5').update(JSON.stringify(content)).digest('hex') : null;

const FALLBACK_DEFAULT_OUTPUT_ARTIFACT = '';

/********************************************
 * Data model section (not exposed)
 ********************************************/

export interface Metadata {
  lineIndices: Lazy<Array<number>>;
  
  // inputSourceMap: LazyPromise<RawSourceMap>;
  // sourceMap: LazyPromise<RawSourceMap>;
  // sourceMapEachMappingByLine: LazyPromise<Array<Array<MappingItem>>>;
}

export interface Data {
  name: string;
  artifactType: string;
  metadata: Metadata;
  identity: Array<string>;

  writeToDisk?: Promise<void>;
  cached?: string;
  cachedAst?: YAMLNode;
  cachedObject?: any;
  accessed?: boolean;
}

interface Store { [uri: string]: Data }

/********************************************
 * Central data controller
 * - one stop for creating data
 * - ensures WRITE ONCE model
 ********************************************/

export interface PipeState {
  skipping?: boolean;
  excludeFromCache?: boolean;
}

export function mergePipeStates(result: PipeState, ...pipeStates: Array<PipeState>) {
  for (const each of pipeStates) {
    result.skipping === undefined ? each.skipping : result.skipping && each.skipping;
    result.excludeFromCache === undefined ? each.excludeFromCache : result.excludeFromCache || each.excludeFromCache;
  }
  return result;
}

export abstract class DataSource {
  public pipeState: PipeState;
  public abstract Enum(): Promise<Array<string>>;
  public abstract Read(uri: string): Promise<DataHandle | null>;

  constructor() {
    this.pipeState = {};
  }

  get skip(): boolean {
    return !!this.pipeState.skipping;
  }
  get cachable(): boolean {
    return !this.pipeState.excludeFromCache;
  }
  set cachable(value: boolean) {
    this.pipeState.excludeFromCache = !value;
  }

  public async ReadStrict(uri: string): Promise<DataHandle> {
    const result = await this.Read(uri);
    if (result === null) {
      throw new Error(`Could not read '${uri}'.`);
    }
    return result;
  }
}

export class QuickDataSource extends DataSource {
  public constructor(private handles: Array<DataHandle>, pipeState?: PipeState) {
    super();
    this.pipeState = pipeState || {};
  }

  public async Enum(): Promise<Array<string>> {
    return this.pipeState.skipping ? new Array<string>() : this.handles.map(x => x.key);
  }

  public async Read(key: string): Promise<DataHandle | null> {
    if (this.pipeState.skipping) {
      return null;
    }
    const data = this.handles.filter(x => x.key === key)[0];
    return data || null;
  }
}

class ReadThroughDataSource extends DataSource {
  private uris: Array<string> = [];
  private cache: { [uri: string]: Promise<DataHandle | null> } = {};

  constructor(private store: DataStore, private fs: IFileSystem) {
    super();
  }


  get cachable(): boolean {
    // filesystem based data source can't cache
    return false;
  }

  public async Read(uri: string): Promise<DataHandle | null> {
    // sync cache (inner stuff is racey!)
    if (!this.cache[uri]) {
      this.cache[uri] = (async () => {
        // probe data store
        try {
          const existingData = await this.store.Read(uri);
          this.uris.push(uri);
          return existingData;
        } catch (e) {
        }

        // populate cache
        let data: string | null = null;
        try {
          data = await this.fs.ReadFile(uri) || await ReadUri(uri);
          if (data) {
            const parent = ParentFolderUri(uri) || '';
            // hack to let $(this-folder) resolve to the location...
            data = data.replace(/\$\(this-folder\)\/*/g, parent);
          }
        } finally {
          if (!data) {
            return null;
          }
        }
        const readHandle = await this.store.WriteData(uri, data, 'input-file', [uri]);

        this.uris.push(uri);
        return readHandle;
      })();
    }

    return this.cache[uri];
  }

  public async Enum(): Promise<Array<string>> {
    return this.uris;
  }
}

export class DataStore {
  public static readonly BaseUri = 'mem://';
  public readonly BaseUri = DataStore.BaseUri;
  private store: Store = {};
  private cacheFolder?: string;

  public constructor(private cancellationToken: CancellationToken = CancellationToken.None) {
  }

  private async getCacheFolder() {
    if (!this.cacheFolder) {
      this.cacheFolder = await fs.mkdtemp(join(tmpdir(), 'autorest-'));
    }
    return this.cacheFolder;
  }

  private ThrowIfCancelled(): void {
    if (this.cancellationToken.isCancellationRequested) {
      throw new OperationCanceledException();
    }
  }

  public GetReadThroughScope(fs: IFileSystem): DataSource {
    return new ReadThroughDataSource(this, fs);
  }

  /****************
   * Data access
   ***************/

  private uid = 0;

  private async WriteDataInternal(uri: string, data: string, artifactType: string, identity: Array<string>, metadata: Metadata): Promise<DataHandle> {
    this.ThrowIfCancelled();
    if (this.store[uri]) {
      throw new Error(`can only write '${uri}' once`);
    }

    // make a sanitized name
    let filename = uri.replace(/[^\w.()]+/g, '-');
    if (filename.length > 64) {
      filename = `${md5(filename)}-${filename.substr(filename.length - 64)}`;
    }
    const name = join(await this.getCacheFolder(), filename);

    this.store[uri] = {
      name,
      cached: data,
      artifactType,
      identity,
      metadata,
    };

    return this.Read(uri);
  }

  public async WriteData(description: string, data: string, artifact: string, identity: Array<string>, sourceMapFactory?: (self: DataHandle) => Promise<RawSourceMap>): Promise<DataHandle> {
    const uri = this.createUri(description);

    // metadata
    const metadata: Metadata = {} as any;

    const result = await this.WriteDataInternal(uri, data, artifact, identity, metadata);

    // metadata.artifactType = artifact;

    // metadata.sourceMap = new LazyPromise(async () => {
    //   if (!sourceMapFactory) {
    //     return new SourceMapGenerator().toJSON();
    //   }
    //   const sourceMap = await sourceMapFactory(result);

    //   // validate
    //   const inputFiles = sourceMap.sources.concat(sourceMap.file);
    //   for (const inputFile of inputFiles) {
    //     if (!this.store[inputFile]) {
    //       throw new Error(`Source map of '${uri}' references '${inputFile}' which does not exist`);
    //     }
    //   }

    //   return sourceMap;
    // });


    // metadata.sourceMapEachMappingByLine = new LazyPromise<Array<Array<MappingItem>>>(async () => {
    //   const result: Array<Array<MappingItem>> = [];

    //   const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);

    //   // does NOT support multiple sources :(
    //   // `singleResult` has null-properties if there is no original

    //   // get coinciding sources
    //   sourceMapConsumer.eachMapping(mapping => {
    //     while (result.length <= mapping.generatedLine) {
    //       result.push([]);
    //     }
    //     result[mapping.generatedLine].push(mapping);
    //   });

    //   return result;
    // });

    // metadata.inputSourceMap = new LazyPromise(() => this.CreateInputSourceMapFor(uri));
    metadata.lineIndices = new Lazy<Array<number>>(() => LineIndices(data));

    return result;
  }

  private createUri(description: string): string {
    return ResolveUri(this.BaseUri, `${this.uid++}?${encodeURIComponent(description)}`);
  }

  public getDataSink(defaultArtifact: string = FALLBACK_DEFAULT_OUTPUT_ARTIFACT): DataSink {
    return new DataSink(
      (description, data, artifact, identity, sourceMapFactory) => this.WriteData(description, data, artifact || defaultArtifact, identity, sourceMapFactory),
      async (description, input) => {
        const uri = this.createUri(description);
        this.store[uri] = this.store[input.key];
        return this.Read(uri);
      }
    );
  }

  public ReadStrictSync(absoluteUri: string): DataHandle {
    const entry = this.store[absoluteUri];
    if (entry === undefined) {
      throw new Error(`Object '${absoluteUri}' does not exist.`);
    }
    return new DataHandle(absoluteUri, entry);
  }

  public async Read(uri: string): Promise<DataHandle> {
    uri = ResolveUri(this.BaseUri, uri);
    const data = this.store[uri];
    if (!data) {
      throw new Error(`Could not read '${uri}'.`);
    }
    return new DataHandle(uri, data);
  }

  public async Blame(absoluteUri: string, position: SmartPosition): Promise<BlameTree> {
    const data = this.ReadStrictSync(absoluteUri);
    const resolvedPosition = await CompilePosition(position, data);
    return await BlameTree.Create(this, {
      source: absoluteUri,
      column: resolvedPosition.column,
      line: resolvedPosition.line,
      name: `blameRoot (${JSON.stringify(position)})`
    });
  }
  /* DISABLING SOURCE MAP SUPPORT 
  private async CreateInputSourceMapFor(absoluteUri: string): Promise<RawSourceMap> {
    const data = this.ReadStrictSync(absoluteUri);

    // retrieve all target positions
    const targetPositions: Array<SmartPosition> = [];
    const metadata = data.metadata;
    const sourceMapConsumer = new SourceMapConsumer(await metadata.sourceMap);
    sourceMapConsumer.eachMapping(m => targetPositions.push(<Position>{ column: m.generatedColumn, line: m.generatedLine }));

    // collect blame
    const mappings: Array<Mapping> = [];
    for (const targetPosition of targetPositions) {
      const blameTree = await this.Blame(absoluteUri, targetPosition);
      const inputPositions = blameTree.BlameLeafs();
      for (const inputPosition of inputPositions) {
        mappings.push({
          name: inputPosition.name,
          source: this.ReadStrictSync(inputPosition.source).Description, // friendly name
          generated: blameTree.node,
          original: inputPosition
        });
      }
    }
    const sourceMapGenerator = new SourceMapGenerator({ file: absoluteUri });
    Compile(mappings, sourceMapGenerator);
    return sourceMapGenerator.toJSON();
  }
  */
}

/********************************************
 * Data handles
 * - provide well-defined access to specific data
 * - provide convenience methods
 ********************************************/

export class DataSink {
  constructor(
    private write: (description: string, rawData: string, artifact: string | undefined, identity: Array<string>, metadataFactory: (readHandle: DataHandle) => Promise<RawSourceMap>) => Promise<DataHandle>,
    private forward: (description: string, input: DataHandle) => Promise<DataHandle>) {
  }

  public async WriteDataWithSourceMap(description: string, data: string, artifact: string | undefined, identity: Array<string>, sourceMapFactory: (readHandle: DataHandle) => Promise<RawSourceMap>): Promise<DataHandle> {
    return this.write(description, data, artifact, identity, sourceMapFactory);
  }

  public async WriteData(description: string, data: string, identity: Array<string>, artifact?: string, mappings: Array<Mapping> = [], mappingSources: Array<DataHandle> = []): Promise<DataHandle> {
    return this.WriteDataWithSourceMap(description, data, artifact, identity, async readHandle => {
      const sourceMapGenerator = new SourceMapGenerator({ file: readHandle.key });
      await Compile(mappings, sourceMapGenerator, mappingSources.concat(readHandle));
      return sourceMapGenerator.toJSON();
    });
  }

  public WriteObject<T>(description: string, obj: T, identity: Array<string>, artifact?: string, mappings: Array<Mapping> = [], mappingSources: Array<DataHandle> = []): Promise<DataHandle> {
    return this.WriteData(description, FastStringify(obj), identity, artifact, mappings, mappingSources);
  }

  public Forward(description: string, input: DataHandle): Promise<DataHandle> {
    return this.forward(description, input);
  }
}

export class DataHandle {
  constructor(public readonly key: string, private item: Data) {
    // start the clock once this has been created.
    // this ensures that the data cache will be flushed if not 
    // used in a reasonable amount of time
    this.onTimer();
  }

  public async serialize() {
    this.item.name;
    return JSON.stringify({
      key: this.Description,
      artifactType: this.item.artifactType,
      identity: this.item.identity,
      name: this.item.name,
      content: await this.ReadData(true)
    });
  }

  private async onTimer() {
    await Delay(3000);

    if (this.item.accessed) {
      // it's been cached. start the timer!
      this.onTimer();

      // clear the accessed flag before we go.
      this.item.accessed = false;
      return;
    }
    // wasn't actually used since the delay. let's dump it.
    // console.log(`flushing ${this.item.name}`);

    // wait to make sure it's finished writing to disk tho'
    // await this.item.writingToDisk;
    if (!this.item.writeToDisk) {
      this.item.writeToDisk = fs.writeFile(this.item.name, this.item.cached);
    }

    // clear the caches.
    this.item.cached = undefined;
    this.item.cachedObject = undefined;
    this.item.cachedAst = undefined;
  }

  public get originalDirectory() {
    const id = this.identity[0];
    return id.substring(0, id.lastIndexOf('/'));
  }

  public get originalFullPath() {
    return this.identity[0];
  }

  public get identity() {
    return this.item.identity;
  }

  public async ReadData(nocache = false): Promise<string> {
    if (!nocache) {
      // we're going to use the data, so let's not let it expire.
      this.item.accessed = true;
    }
    // if it's not cached, load it from disk.
    if (this.item.cached === undefined) {
      // make sure the write-to-disk is finished.
      await this.item.writeToDisk;

      if (nocache) {
        return await fs.readFile(this.item.name, 'utf8');
      } else {
        this.item.cached = await fs.readFile(this.item.name, 'utf8');

        // start the timer again.
        this.onTimer();
      }
    }

    return this.item.cached;
  }

  public async ReadObjectFast<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;

    return this.item.cachedObject || (this.item.cachedObject = parseYaml(await this.ReadData()));
  }

  public async ReadObject<T>(): Promise<T> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;

    // return the cached object, or get it, then return it.
    return this.item.cachedObject || (this.item.cachedObject = ParseNode<T>(await this.ReadYamlAst()));
  }

  public async ReadYamlAst(): Promise<YAMLNode> {
    // we're going to use the data, so let's not let it expire.
    this.item.accessed = true;
    // return the cachedAst or get it, then return it.
    return this.item.cachedAst || (this.item.cachedAst = parseAst(await this.ReadData()));
  }

  public get metadata(): Metadata {
    return this.item.metadata;
  }

  public get artifactType(): string {
    return this.item.artifactType;
  }

  public get Description(): string {
    return decodeURIComponent(this.key.split('?').reverse()[0]);
  }

  public async IsObject(): Promise<boolean> {
    try {
      await this.ReadObject();
      return true;
    } catch (e) {
      return false;
    }
  }

  public async Blame(position: Position): Promise<Array<MappedPosition>> {
    return [];
    /* DISABLING SOURCE MAP SUPPORT 
    const metadata = this.metadata;
    const sameLineResults = ((await metadata.sourceMapEachMappingByLine)[position.line] || [])
      .filter(mapping => mapping.generatedColumn <= position.column);
    const maxColumn = sameLineResults.reduce((c, m) => Math.max(c, m.generatedColumn), 0);
    const columnDelta = position.column - maxColumn;
    return sameLineResults.filter(m => m.generatedColumn === maxColumn).map(m => {
      return {
        column: m.originalColumn + columnDelta,
        line: m.originalLine,
        name: m.name,
        source: m.source
      };
    });
    */
  }
}
