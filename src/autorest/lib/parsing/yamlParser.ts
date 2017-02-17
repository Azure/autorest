/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as yaml from "js-yaml";
import * as yamlAst from "yaml-ast-parser";
import * as sourceMap from "source-map";
import * as jsonpath from "jsonpath";

export function parseYaml<T>(rawYaml: string): T {
    return yaml.safeLoad(rawYaml);
}

type ObjectSourceMap = { [jsonPath: string]: { start: sourceMap.Position, end: sourceMap.Position } };

function textLineStartIndices(text: string): number[] {
    let indices = [0];

    let regex = /\r?\n/g;
    let match: RegExpExecArray | null;
    while ((match = regex.exec(text)) !== null) {
        indices.push(match.index + match[0].length);
    }

    return indices;
}

function textIndexToPosition(text: string, index: number): sourceMap.Position {
    let startIndices = textLineStartIndices(text);
    let lineIndex = startIndices.map(i => i <= index).lastIndexOf(true); // TODO: binary search?

    return {
        column: index - startIndices[lineIndex],
        line: 1 + lineIndex
    };
}

function createIdentitySourceMapForAST(srcMapGen: sourceMap.SourceMapGenerator, rawInput: string, rawOutput: string, astIn: yamlAst.YAMLNode, astOut: yamlAst.YAMLNode, objectPath: jsonpath.PathComponent[]): void {
    if (astIn.anchorId != astOut.anchorId ||
        astIn.kind != astOut.kind) {
        throw "object mismatch";
    }

    var jsonPath = jsonpath.stringify(objectPath);

    srcMapGen.addMapping({
        original: textIndexToPosition(rawInput, astIn.startPosition),
        generated: textIndexToPosition(rawOutput, astOut.startPosition),
        source: "in.js",
        name: jsonPath
    });
    srcMapGen.addMapping({
        original: textIndexToPosition(rawInput, astIn.endPosition),
        generated: textIndexToPosition(rawOutput, astOut.endPosition),
        source: "in.js",
        name: jsonPath
    });

    switch (astIn.kind)
    {
        case yamlAst.Kind.SCALAR:
            break;
        case yamlAst.Kind.MAPPING: {
            let astSubIn = astIn as yamlAst.YAMLMapping;
            let astSubOut = astOut as yamlAst.YAMLMapping;
            createIdentitySourceMapForAST(srcMapGen, rawInput, rawOutput, astSubIn.key, astSubOut.key, objectPath);
            createIdentitySourceMapForAST(srcMapGen, rawInput, rawOutput, astSubIn.value, astSubOut.value, objectPath);
            break;
        }
        case yamlAst.Kind.MAP: {
            let astSubIn = astIn as yamlAst.YamlMap;
            let astSubOut = astOut as yamlAst.YamlMap;
            if (astSubIn.mappings.length != astSubOut.mappings.length) {
                throw "object mismatch";
            }
            for (var i = 0; i < astSubOut.mappings.length; ++i) {
                createIdentitySourceMapForAST(srcMapGen, rawInput, rawOutput, astSubIn.mappings[i], astSubOut.mappings[i], objectPath.concat([astSubOut.mappings[i].key.value]));
            }
            break;
        }
        case yamlAst.Kind.SEQ: {
            let astSubIn = astIn as yamlAst.YAMLSequence;
            let astSubOut = astOut as yamlAst.YAMLSequence;
            if (astSubIn.items.length != astSubOut.items.length) {
                throw "object mismatch";
            }
            for (var i = 0; i < astSubOut.items.length; ++i) {
                createIdentitySourceMapForAST(srcMapGen, rawInput, rawOutput, astSubIn.items[i], astSubOut.items[i], objectPath.concat([i]));
            }
            break;
        }
        case yamlAst.Kind.ANCHOR_REF:
            break;
        case yamlAst.Kind.INCLUDE_REF:
            break;
    }
}

function createIdentitySourceMap(rawInput: string, rawOutput: string): sourceMap.RawSourceMap {
    let astIn = yamlAst.safeLoad(rawInput, null) as yamlAst.YAMLNode;
    let astOut = yamlAst.safeLoad(rawOutput, null) as yamlAst.YAMLNode;
    let srcMapGen = new sourceMap.SourceMapGenerator({ file: "out.js" });

    createIdentitySourceMapForAST(srcMapGen, rawInput, rawOutput, astIn, astOut, ["$"]);

    return srcMapGen.toJSON();
}

export function getYamlSourceMap<T>(rawYaml: string): sourceMap.RawSourceMap {
    let obj = parseYaml<T>(rawYaml);
    let rawYamlOut = yaml.safeDump(obj);
    console.log(rawYaml);
    console.log(rawYamlOut);
    return createIdentitySourceMap(rawYaml, rawYamlOut);
}
