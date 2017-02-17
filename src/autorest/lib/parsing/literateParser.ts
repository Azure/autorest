/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

import * as commonmark from "commonmark";
import * as fs from "fs";
import * as path from "path";
import * as promisify from "pify";

interface fsAsync
{
    /*
     * Asynchronous readFile - Asynchronously reads the entire contents of a file.
     *
     * @param fileName
     * @param encoding
     */
    readFile(filename: string, encoding: string): Promise<string>;
    /*
     * Asynchronous readFile - Asynchronously reads the entire contents of a file.
     *
     * @param fileName
     * @param options An object with optional {encoding} and {flag} properties.  If {encoding} is specified, readFile returns a string; otherwise it returns a Buffer.
     */
    readFile(filename: string, options: { encoding: string; flag?: string; }): Promise<string>;
    /*
     * Asynchronous readFile - Asynchronously reads the entire contents of a file.
     *
     * @param fileName
     * @param options An object with optional {encoding} and {flag} properties.  If {encoding} is specified, readFile returns a string; otherwise it returns a Buffer.
     */
    readFile(filename: string, options: { flag?: string; }): Promise<Buffer>;
    /*
     * Asynchronous readFile - Asynchronously reads the entire contents of a file.
     *
     * @param fileName
     */
    readFile(filename: string): Promise<Buffer>;
}
var fsAsync: fsAsync = promisify(fs);

function ast(node: commonmark.Node): any {
    if (node.type === "text") {
        return node.literal;
    }

    let result: any = {};
    // result.info = node.info;
    // result.isContainer = node.isContainer;
    if (node.level) {
        result.level = node.level;
    }
    if (node.literal) {
        result.literal = node.literal;
    }
    // result.sourcepos = node.sourcepos;
    result.type = node.type;
    result.children = [];

    var child = node.firstChild;
    while (child != null) {
        result.children.push(ast(child));
        child = child.next;
    }
    if (result.children.length === 0) {
        delete result.children;
    }

    return result;
}

export async function test() {
    let parser = new commonmark.Parser();
    let inputFile = path.join(__dirname, "../..", "../..", "../../../../../..", "docs/proposals/generator-specific-settings/sample1.autorest.md");
    let inputFileContent = await fsAsync.readFile(inputFile, "utf8");
    let parsed = parser.parse(inputFileContent);

    // console.log(parsed);
    console.log(JSON.stringify(ast(parsed), null, 2));

    let walker = parsed.walker();
    let event: commonmark.NodeWalkingStep;
    while ((event = walker.next())) {
        var node = event.node;
        if (event.entering && node.type === "code_block") {
            console.warn(node.info);
            // console.log(node.);
        }
    }
}

class LiterateParser {

}