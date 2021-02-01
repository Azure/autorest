// ---------------------------------------------------------------------------------------------
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License. See License.txt in the project root for license information.
// ---------------------------------------------------------------------------------------------

import { RawSourceMap, SourceMapConsumer } from "source-map";

/* @internal */
export type JsonPath = Array<number | string>;

/* @internal */
export class SourceMap {
  private consumer: SourceMapConsumer;

  public constructor(map: RawSourceMap) {
    this.consumer = new SourceMapConsumer(map);
  }

  /**
   * Uses the source map to determine which mappings are associated with a certain JSON path.
   * @param path  The JSON path to lookup.
   */
  public LookupPath(path: JsonPath): Array<sourceMap.MappingItem> {
    const result: Array<sourceMap.MappingItem> = [];
    this.consumer.eachMapping((mi) => {
      const itemPath = this.ExtractJsonPath(mi);
      if (
        itemPath &&
        itemPath.length === path.length &&
        itemPath.every((part, index) => itemPath[index].toString() === path[index].toString())
      ) {
        result.push(mi);
      }
    });
    return result;
  }

  /**
   * Uses the source map to determine which locations in the generated file where influenced by given location in a source file.
   * @param file    Source file having influenced the generated file.
   * @param line    Line in the source file having influenced the generated file.
   * @param column  Column in the source file having influenced the generated file.
   */
  public LookupForward(
    file: string,
    line: number,
    column: number,
  ): Array<{ line: number; column: number; path: JsonPath | null }> {
    const sameLineResults: Array<sourceMap.MappingItem> = [];
    this.consumer.eachMapping((mi) => {
      if (
        (mi.source === file || decodeURIComponent(mi.source) === decodeURIComponent(file)) &&
        mi.originalLine === line &&
        mi.originalColumn <= column
      ) {
        sameLineResults.push(mi);
      }
    });
    const maxColumn = sameLineResults.map((mi) => mi.originalColumn).reduce((a, b) => Math.max(a, b), 0);
    return sameLineResults
      .filter((mi) => mi.originalColumn === maxColumn)
      .map((mi) => ({ line: mi.generatedLine, column: mi.generatedColumn, path: this.ExtractJsonPath(mi) }));
  }

  /**
   * Uses the source map to determine which locations in the source files where influenced by given location in the generated file.
   * @param line    Line in the generated file having influenced the generated file.
   * @param column  Column in the generated file having influenced the generated file.
   */
  public LookupBackwards(
    line: number,
    column: number,
  ): Array<{ file: string; line: number; column: number; path: JsonPath | null }> {
    const sameLineResults: Array<sourceMap.MappingItem> = [];
    this.consumer.eachMapping((mi) => {
      if (mi.generatedLine === line && mi.generatedColumn <= column) {
        sameLineResults.push(mi);
      }
    });
    const maxColumn = sameLineResults.map((mi) => mi.generatedColumn).reduce((a, b) => Math.max(a, b), 0);
    return sameLineResults
      .filter((mi) => mi.generatedColumn === maxColumn)
      .map((mi) => ({
        file: mi.source,
        line: mi.originalLine,
        column: mi.originalColumn,
        path: this.ExtractJsonPath(mi),
      }));
  }

  /**
   * AutoRest stores rich information in the "name" field available in source maps.
   * This function tries to extract a JSON path from a mapping.
   * @param mi The mapping to extract the JSON path from.
   */
  private ExtractJsonPath(mi: sourceMap.MappingItem): JsonPath | null {
    try {
      const pathPart = mi.name.split("\n")[0];
      return JSON.parse(pathPart);
    } catch (e) {
      // eslint-disable-next-line no-console
      console.warn("Failed obtaining object path from mapping item", e);
      return null;
    }
  }
}
