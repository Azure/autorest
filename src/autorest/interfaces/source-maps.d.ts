declare module "jsonpath" {

  type PathComponent = string | number;

  export function query(obj: any, pathExpression: string): any[];
  export function paths(obj: any, pathExpression: string): PathComponent[][];
  export function nodes(obj: any, pathExpression: string): { path: PathComponent[]; value: any; }[];
  export function value(obj: any, pathExpression: string): any;
  export function value(obj: any, pathExpression: string, newValue: any): any;
  export function parent(obj: any, pathExpression: string): any;
  export function apply(obj: any, pathExpression: string, fn: (x: any) => any): { path: PathComponent[]; value: any; }[];
  export function parse(pathExpression: string): any[];
  export function stringify(path: PathComponent[]): string;

}

declare module "source-map" {

  export type SourceMapUrl = string;

  export interface StartOfSourceMap {
    file?: string;
    sourceRoot?: string;
    skipValidation?: boolean;
  }

  export interface RawSourceMap {
    version: number;
    sources: string[];
    names: string[];
    sourceRoot?: string;
    sourcesContent?: string[];
    mappings: string;
    file: string;
  }

  export interface RawIndexMap extends StartOfSourceMap {
    version: number;
    sections: RawSection[];
  }

  export interface RawSection {
    offset: Position;
    map: RawSourceMap;
  }

  export interface Position {
    line: number;
    column: number;
  }

  export interface NullablePosition {
    line: number | null;
    column: number | null;
    lastColumn: number | null;
  }

  export interface MappedPosition {
    source: string;
    line: number;
    column: number;
    name?: string;
  }

  export interface NullableMappedPosition {
    source: string | null;
    line: number | null;
    column: number | null;
    name: string | null;
  }

  export interface MappingItem {
    source: string;
    generatedLine: number;
    generatedColumn: number;
    originalLine: number;
    originalColumn: number;
    name: string;
  }

  export interface Mapping {
    generated: Position;
    original: Position;
    source: string;
    name?: string;
  }

  export interface CodeWithSourceMap {
    code: string;
    map: SourceMapGenerator;
  }

  export interface SourceMapConsumer {
    /**
     * Compute the last column for each generated mapping. The last column is
     * inclusive.
     */
    computeColumnSpans(): void;

    /**
     * Returns the original source, line, and column information for the generated
     * source's line and column positions provided. The only argument is an object
     * with the following properties:
     *
     *   - line: The line number in the generated source.
     *   - column: The column number in the generated source.
     *   - bias: Either 'SourceMapConsumer.GREATEST_LOWER_BOUND' or
     *     'SourceMapConsumer.LEAST_UPPER_BOUND'. Specifies whether to return the
     *     closest element that is smaller than or greater than the one we are
     *     searching for, respectively, if the exact element cannot be found.
     *     Defaults to 'SourceMapConsumer.GREATEST_LOWER_BOUND'.
     *
     * and an object is returned with the following properties:
     *
     *   - source: The original source file, or null.
     *   - line: The line number in the original source, or null.
     *   - column: The column number in the original source, or null.
     *   - name: The original identifier, or null.
     */
    originalPositionFor(generatedPosition: Position & { bias?: number }): NullableMappedPosition;

    /**
     * Returns the generated line and column information for the original source,
     * line, and column positions provided. The only argument is an object with
     * the following properties:
     *
     *   - source: The filename of the original source.
     *   - line: The line number in the original source.
     *   - column: The column number in the original source.
     *   - bias: Either 'SourceMapConsumer.GREATEST_LOWER_BOUND' or
     *     'SourceMapConsumer.LEAST_UPPER_BOUND'. Specifies whether to return the
     *     closest element that is smaller than or greater than the one we are
     *     searching for, respectively, if the exact element cannot be found.
     *     Defaults to 'SourceMapConsumer.GREATEST_LOWER_BOUND'.
     *
     * and an object is returned with the following properties:
     *
     *   - line: The line number in the generated source, or null.
     *   - column: The column number in the generated source, or null.
     */
    generatedPositionFor(originalPosition: MappedPosition & { bias?: number }): NullablePosition;

    /**
     * Returns all generated line and column information for the original source,
     * line, and column provided. If no column is provided, returns all mappings
     * corresponding to a either the line we are searching for or the next
     * closest line that has any mappings. Otherwise, returns all mappings
     * corresponding to the given line and either the column we are searching for
     * or the next closest column that has any offsets.
     *
     * The only argument is an object with the following properties:
     *
     *   - source: The filename of the original source.
     *   - line: The line number in the original source.
     *   - column: Optional. the column number in the original source.
     *
     * and an array of objects is returned, each with the following properties:
     *
     *   - line: The line number in the generated source, or null.
     *   - column: The column number in the generated source, or null.
     */
    allGeneratedPositionsFor(originalPosition: MappedPosition): NullablePosition[];

    /**
     * Return true if we have the source content for every source in the source
     * map, false otherwise.
     */
    hasContentsOfAllSources(): boolean;

    /**
     * Returns the original source content. The only argument is the url of the
     * original source file. Returns null if no original source content is
     * available.
     */
    sourceContentFor(source: string, returnNullOnMissing?: boolean): string | null;

    /**
     * Iterate over each mapping between an original source/line/column and a
     * generated line/column in this source map.
     *
     * @param callback
     *        The function that is called with each mapping.
     * @param context
     *        Optional. If specified, this object will be the value of `this` every
     *        time that `aCallback` is called.
     * @param order
     *        Either `SourceMapConsumer.GENERATED_ORDER` or
     *        `SourceMapConsumer.ORIGINAL_ORDER`. Specifies whether you want to
     *        iterate over the mappings sorted by the generated file's line/column
     *        order or the original's source/line/column order, respectively. Defaults to
     *        `SourceMapConsumer.GENERATED_ORDER`.
     */
    eachMapping(callback: (mapping: MappingItem) => void, context?: any, order?: number): void;
  }

  export interface SourceMapConsumerConstructor {
    prototype: SourceMapConsumer;

    GENERATED_ORDER: number;
    ORIGINAL_ORDER: number;
    GREATEST_LOWER_BOUND: number;
    LEAST_UPPER_BOUND: number;

    new(rawSourceMap: RawSourceMap, sourceMapUrl?: SourceMapUrl): BasicSourceMapConsumer;
    new(rawSourceMap: RawIndexMap, sourceMapUrl?: SourceMapUrl): IndexedSourceMapConsumer;
    new(rawSourceMap: RawSourceMap | RawIndexMap | string, sourceMapUrl?: SourceMapUrl): BasicSourceMapConsumer | IndexedSourceMapConsumer;

    /**
     * Create a BasicSourceMapConsumer from a SourceMapGenerator.
     *
     * @param sourceMap
     *        The source map that will be consumed.
     */
    fromSourceMap(sourceMap: SourceMapGenerator, sourceMapUrl?: SourceMapUrl): BasicSourceMapConsumer;
  }

  export const SourceMapConsumer: SourceMapConsumerConstructor;

  export interface BasicSourceMapConsumer extends SourceMapConsumer {
    file: string;
    sourceRoot: string;
    sources: string[];
    sourcesContent: string[];
  }

  export interface BasicSourceMapConsumerConstructor {
    prototype: BasicSourceMapConsumer;

    new(rawSourceMap: RawSourceMap | string): BasicSourceMapConsumer;

    /**
     * Create a BasicSourceMapConsumer from a SourceMapGenerator.
     *
     * @param sourceMap
     *        The source map that will be consumed.
     */
    fromSourceMap(sourceMap: SourceMapGenerator): BasicSourceMapConsumer;
  }

  export const BasicSourceMapConsumer: BasicSourceMapConsumerConstructor;

  export interface IndexedSourceMapConsumer extends SourceMapConsumer {
    sources: string[];
  }

  export interface IndexedSourceMapConsumerConstructor {
    prototype: IndexedSourceMapConsumer;

    new(rawSourceMap: RawIndexMap | string): IndexedSourceMapConsumer;
  }

  export const IndexedSourceMapConsumer: IndexedSourceMapConsumerConstructor;

  export class SourceMapGenerator {
    constructor(startOfSourceMap?: StartOfSourceMap);

    /**
     * Creates a new SourceMapGenerator based on a SourceMapConsumer
     *
     * @param sourceMapConsumer The SourceMap.
     */
    static fromSourceMap(sourceMapConsumer: SourceMapConsumer): SourceMapGenerator;

    /**
     * Add a single mapping from original source line and column to the generated
     * source's line and column for this source map being created. The mapping
     * object should have the following properties:
     *
     *   - generated: An object with the generated line and column positions.
     *   - original: An object with the original line and column positions.
     *   - source: The original source file (relative to the sourceRoot).
     *   - name: An optional original token name for this mapping.
     */
    addMapping(mapping: Mapping): void;

    /**
     * Set the source content for a source file.
     */
    setSourceContent(sourceFile: string, sourceContent: string): void;

    /**
     * Applies the mappings of a sub-source-map for a specific source file to the
     * source map being generated. Each mapping to the supplied source file is
     * rewritten using the supplied source map. Note: The resolution for the
     * resulting mappings is the minimium of this map and the supplied map.
     *
     * @param sourceMapConsumer The source map to be applied.
     * @param sourceFile Optional. The filename of the source file.
     *        If omitted, SourceMapConsumer's file property will be used.
     * @param sourceMapPath Optional. The dirname of the path to the source map
     *        to be applied. If relative, it is relative to the SourceMapConsumer.
     *        This parameter is needed when the two source maps aren't in the same
     *        directory, and the source map to be applied contains relative source
     *        paths. If so, those relative source paths need to be rewritten
     *        relative to the SourceMapGenerator.
     */
    applySourceMap(sourceMapConsumer: SourceMapConsumer, sourceFile?: string, sourceMapPath?: string): void;

    toString(): string;

    toJSON(): RawSourceMap;
  }

  export class SourceNode {
    children: SourceNode[];
    sourceContents: any;
    line: number;
    column: number;
    source: string;
    name: string;

    constructor();
    constructor(
      line: number | null,
      column: number | null,
      source: string | null,
      chunks?: Array<(string | SourceNode)> | SourceNode | string,
      name?: string
    );

    static fromStringWithSourceMap(
      code: string,
      sourceMapConsumer: SourceMapConsumer,
      relativePath?: string
    ): SourceNode;

    add(chunk: Array<(string | SourceNode)> | SourceNode | string): SourceNode;

    prepend(chunk: Array<(string | SourceNode)> | SourceNode | string): SourceNode;

    setSourceContent(sourceFile: string, sourceContent: string): void;

    walk(fn: (chunk: string, mapping: MappedPosition) => void): void;

    walkSourceContents(fn: (file: string, content: string) => void): void;

    join(sep: string): SourceNode;

    replaceRight(pattern: string, replacement: string): SourceNode;

    toString(): string;

    toStringWithSourceMap(startOfSourceMap?: StartOfSourceMap): CodeWithSourceMap;
  }

}

declare module "commonmark" {
  // Type definitions for commonmark.js 0.27
  // Project: https://github.com/jgm/commonmark.js
  // Definitions by: Nico Jansen <https://github.com/nicojs>
  //                 Leonard Thieu <https://github.com/leonard-thieu>
  // Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

  export class Node {
    constructor(nodeType: string, sourcepos?: Position);

    /**
     * (read-only): a String, one of text, softbreak, linebreak, emph, strong, html_inline, link, image, code, document, paragraph,
     * block_quote, item, list, heading, code_block, html_block, thematic_break.
     */
    readonly type: 'text' | 'softbreak' | 'linebreak' | 'emph' | 'strong' | 'html_inline' | 'link' | 'image' | 'code' | 'document' | 'paragraph' |
    'block_quote' | 'item' | 'list' | 'heading' | 'code_block' | 'html_block' | 'thematic_break' | 'custom_inline' | 'custom_block';
    /**
     * (read-only): a Node or null.
     */
    readonly firstChild: Node | null;
    /**
     * (read-only): a Node or null.
     */
    readonly lastChild: Node | null;
    /**
     * (read-only): a Node or null.
     */
    readonly next: Node | null;
    /**
     * (read-only): a Node or null.
     */
    readonly prev: Node | null;
    /**
     * (read-only): a Node or null.
     */
    readonly parent: Node | null;
    /**
     * (read-only): an Array with the following form: [[startline, startcolumn], [endline, endcolumn]]
     */
    readonly sourcepos: Position;
    /**
     * (read-only): true if the Node can contain other Nodes as children.
     */
    readonly isContainer: boolean;
    /**
     *  the literal String content of the node or null.
     */
    literal: string | null;
    /**
     * link or image destination (String) or null.
     */
    destination: string | null;
    /**
     *  link or image title (String) or null.
     */
    title: string | null;
    /**
     * fenced code block info string (String) or null.
     */
    info: string | null;
    /**
     * heading level (Number).
     */
    level: number;
    /**
     * either Bullet or Ordered (or undefined).
     */
    listType: 'Bullet' | 'Ordered';
    /**
     * true if list is tight
     */
    listTight: boolean;
    /**
     * a Number, the starting number of an ordered list.
     */
    listStart: number;
    /**
     * a String, either ) or . for an ordered list.
     */
    listDelimiter: ')' | '.';
    /**
     * used only for CustomBlock or CustomInline.
     */
    onEnter: string;
    /**
     * used only for CustomBlock or CustomInline.
     */
    onExit: string;

    /**
     * Append a Node child to the end of the Node's children.
     */
    appendChild(child: Node): void;

    /**
     *  Prepend a Node child to the beginning of the Node's children.
     */
    prependChild(child: Node): void;

    /**
     *  Remove the Node from the tree, severing its links with siblings and parents, and closing up gaps as needed.
     */
    unlink(): void;

    /**
     * Insert a Node sibling after the Node.
     */
    insertAfter(sibling: Node): void;

    /**
     * Insert a Node sibling before the Node.
     */
    insertBefore(sibling: Node): void;

    /**
     * Returns a NodeWalker that can be used to iterate through the Node tree rooted in the Node
     */
    walker(): NodeWalker;

    /**
     * Setting the backing object of listType, listTight, listStat and listDelimiter directly.
     * Not needed unless creating list nodes directly. Should be fixed from v>0.22.1
     * https://github.com/jgm/commonmark.js/issues/74
     */
    _listData: ListData;
  }

  /**
   * Instead of converting Markdown directly to HTML, as most converters do, commonmark.js parses Markdown to an AST (abstract syntax tree), and then renders this AST as HTML.
   * This opens up the possibility of manipulating the AST between parsing and rendering. For example, one could transform emphasis into ALL CAPS.
   */
  export class Parser {
    /**
     * Constructs a new Parser
     */
    constructor(options?: ParserOptions);

    parse(input: string): Node;
  }

  export class HtmlRenderer {
    constructor(options?: HtmlRenderingOptions)

    render(root: Node): string;

    /**
     * Let's you override the softbreak properties of a renderer. So, to make soft breaks render as hard breaks in HTML:
     * writer.softbreak = "<br />";
     */
    softbreak: string;
    /**
     * Override the function that will be used to escape (sanitize) the html output. Return value is used to add to the html output
     * @param input the input to escape
     * @param isAttributeValue indicates wheter or not the input value will be used as value of an html attribute.
     */
    escape: (input: string, isAttributeValue: boolean) => string;
  }

  export class XmlRenderer {
    constructor(options?: XmlRenderingOptions)

    render(root: Node): string;
  }
  export interface NodeWalkingStep {
    /**
     * a boolean, which is true when we enter a Node from a parent or sibling, and false when we reenter it from a child
     */
    entering: boolean;
    /**
     * The node belonging to this step
     */
    node: Node;
  }

  export interface NodeWalker {
    /**
     * Returns an object with properties entering and node. Returns null when we have finished walking the tree.
     */
    next(): NodeWalkingStep;
    /**
     * Resets the iterator to resume at the specified node and setting for entering. (Normally this isn't needed unless you do destructive updates to the Node tree.)
     */
    resumeAt(node: Node, entering?: boolean): void;
  }

  export type Position = [[number, number], [number, number]];

  export interface ListData {
    type?: string;
    tight?: boolean;
    delimiter?: string;
    bulletChar?: string;
  }

  export interface ParserOptions {
    /**
     *  if true, straight quotes will be made curly, -- will be changed to an en dash, --- will be changed to an em dash, and ... will be changed to ellipses.
     */
    smart?: boolean;
    time?: boolean;
  }

  export interface HtmlRenderingOptions extends XmlRenderingOptions {
    /**
     *  if true, raw HTML will not be passed through to HTML output (it will be replaced by comments), and potentially unsafe URLs in links and images
     *  (those beginning with javascript:, vbscript:, file:, and with a few exceptions data:) will be replaced with empty strings.
     */
    safe?: boolean;
    /**
     *  if true, straight quotes will be made curly, -- will be changed to an en dash, --- will be changed to an em dash, and ... will be changed to ellipses.
     */
    smart?: boolean;
    /**
     *  if true, source position information for block-level elements will be rendered in the data-sourcepos attribute (for HTML) or the sourcepos attribute (for XML).
     */
    sourcepos?: boolean;
  }

  export interface XmlRenderingOptions {
    time?: boolean;
    sourcepos?: boolean;
  }

}