"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// #!/usr/bin/env node
// load modules from static linker filesystem.
try {
    if (process.argv.indexOf('--no-static-loader') === -1 && process.env['no-static-loader'] === undefined) {
        require('./static-loader.js').load(`${__dirname}/static_modules.fs`);
    }
}
catch (e) {
}
/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
// https://github.com/uxitten/polyfill/blob/master/string.polyfill.js
// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/String/padEnd
if (!String.prototype.padEnd) {
    String.prototype.padEnd = function padEnd(targetLength, padString) {
        targetLength = targetLength >> 0; // floor if number or convert non-number to 0;
        padString = String(padString || ' ');
        if (this.length > targetLength) {
            return String(this);
        }
        else {
            targetLength = targetLength - this.length;
            if (targetLength > padString.length) {
                padString += padString.repeat(targetLength / padString.length); // append to original to ensure we are longer than needed
            }
            return String(this) + padString.slice(0, targetLength);
        }
    };
}
require('events').EventEmitter.defaultMaxListeners = 100;
process.env['ELECTRON_RUN_AS_NODE'] = '1';
delete process.env['ELECTRON_NO_ATTACH_CONSOLE'];
process.on('exit', () => {
    autorest_core_1.Shutdown();
});
const color = global.color ? global.color : p => p;
const path_1 = require("path");
const legacyCli_1 = require("./legacyCli");
const autorest_core_1 = require("./lib/autorest-core");
const configuration_1 = require("./lib/configuration");
// import { DataStore } from "./lib/data-store/data-store";
const datastore_1 = require("@microsoft.azure/datastore");
const exception_1 = require("./lib/exception");
const datastore_2 = require("@microsoft.azure/datastore");
const message_1 = require("./lib/message");
const datastore_3 = require("@microsoft.azure/datastore");
const uri_1 = require("@microsoft.azure/uri");
const datastore_4 = require("@microsoft.azure/datastore");
const merging_1 = require("./lib/source-map/merging");
let verbose = false;
let debug = false;
function awaitable(child) {
    return new Promise((resolve, reject) => {
        child.addListener('error', reject);
        child.addListener('exit', resolve);
    });
}
async function showHelp() {
    await currentMain(['--help']);
}
async function legacyMain(autorestArgs) {
    // generate virtual config file
    const currentDirUri = uri_1.CreateFolderUri(path_1.resolve());
    const dataStore = new datastore_1.DataStore();
    let config = {};
    try {
        config = await legacyCli_1.CreateConfiguration(currentDirUri, dataStore.GetReadThroughScope(new datastore_2.RealFileSystem()), autorestArgs);
    }
    catch (e) {
        console.error(color('!Error: You have provided legacy command line arguments (single-dash syntax) that seem broken.'));
        console.error('');
        console.error(color('> While AutoRest keeps on supporting the old CLI by converting it over to the new one internally, \n' +
            '> it does not have crazy logic determining *what* is wrong with arguments, should conversion fail. \n' +
            '> Please try fixing your arguments or consider moving to the new CLI. \n' +
            '> isit https://github.com/Azure/autorest/blob/master/docs/user/cli.md for information about the new CLI.'));
        console.error('');
        console.error(color('!Internal error: ' + e));
        await showHelp();
        return 1;
    }
    // autorest init
    if (autorestArgs[0] === 'init') {
        const clientNameGuess = (config['override-info'] || {}).title || datastore_4.Parse(await uri_1.ReadUri(config['input-file'][0])).info.title;
        await autorestInit(clientNameGuess, Array.isArray(config['input-file']) ? config['input-file'] : []);
        return 0;
    }
    // autorest init-min
    if (autorestArgs[0] === 'init-min') {
        console.log(`# AutoRest Configuration (auto-generated, please adjust title)

> see https://aka.ms/autorest

The following configuration was auto-generated and can be adjusted.

~~~ yaml
${datastore_4.Stringify(config).replace(/^---\n/, '')}
~~~

`.replace(/~/g, '`'));
        return 0;
    }
    // autorest init-cli
    if (autorestArgs[0] === 'init-cli') {
        const args = [];
        for (const node of datastore_3.nodes(config, '$..*')) {
            const path = node.path.join('.');
            const values = node.value instanceof Array ? node.value : (typeof node.value === 'object' ? [] : [node.value]);
            for (const value of values) {
                args.push(`--${path}=${value}`);
            }
        }
        console.log(args.join(' '));
        return 0;
    }
    config['base-folder'] = currentDirUri;
    const api = new autorest_core_1.AutoRest(new datastore_2.RealFileSystem());
    api.AddConfiguration(config);
    const view = await api.view;
    let outstanding = Promise.resolve();
    api.GeneratedFile.Subscribe((_, file) => outstanding = outstanding.then(() => uri_1.WriteString(file.uri, file.content)));
    api.ClearFolder.Subscribe((_, folder) => outstanding = outstanding.then(async () => { try {
        await uri_1.ClearFolder(folder);
    }
    catch (e) { } }));
    subscribeMessages(api, () => { });
    // warn about `--` arguments
    for (let arg of autorestArgs) {
        if (arg.startsWith('--')) {
            view.Message({
                Channel: message_1.Channel.Warning,
                Text: `The parameter ${arg} looks like it was meant for the new CLI! ` +
                    'Note that you have invoked the legacy CLI (by using at least one single-dash argument). ' +
                    'Please visit https://github.com/Azure/autorest/blob/master/docs/user/cli.md for information about the new CLI.'
            });
        }
    }
    const result = await api.Process().finish;
    if (result != true) {
        throw result;
    }
    await outstanding;
    return 0;
}
function parseArgs(autorestArgs) {
    const result = {
        switches: [],
        rawSwitches: {}
    };
    for (const arg of autorestArgs) {
        const match = /^--([^=:]+)([=:](.+))?$/g.exec(arg);
        // configuration file?
        if (match === null) {
            if (result.configFileOrFolder) {
                throw new Error(`Found multiple configuration file arguments: '${result.configFileOrFolder}', '${arg}'`);
            }
            result.configFileOrFolder = arg;
            continue;
        }
        // switch
        const key = match[1];
        let rawValue = match[3] || '{}';
        if (rawValue.startsWith('.')) {
            // starts with a . or .. -> this is a relative path to current directory
            rawValue = path_1.join(process.cwd(), rawValue);
        }
        // quote stuff beginning with '@', YAML doesn't think unquoted strings should start with that
        rawValue = rawValue.startsWith('@') ? `'${rawValue}'` : rawValue;
        // quote numbers with decimal point, we don't have any use for non-integer numbers (while on the other hand version strings may look like decimal numbers)
        rawValue = !isNaN(parseFloat(rawValue)) && rawValue.includes('.') ? `'${rawValue}'` : rawValue;
        const value = datastore_4.Parse(rawValue);
        result.rawSwitches[key] = value;
        result.switches.push(datastore_3.CreateObject(key.split('.'), value));
    }
    return result;
}
function outputMessage(instance, m, errorCounter) {
    switch (m.Channel) {
        case message_1.Channel.Debug:
            if (debug) {
                console.log(color(m.FormattedMessage || m.Text));
            }
            break;
        case message_1.Channel.Verbose:
            if (verbose) {
                console.log(color(m.FormattedMessage || m.Text));
            }
            break;
        case message_1.Channel.Information:
            console.log(color(m.FormattedMessage || m.Text));
            break;
        case message_1.Channel.Warning:
            console.log(color(m.FormattedMessage || m.Text));
            break;
        case message_1.Channel.Error:
        case message_1.Channel.Fatal:
            errorCounter();
            console.error(color(m.FormattedMessage || m.Text));
            break;
    }
}
function subscribeMessages(api, errorCounter) {
    api.Message.Subscribe((_, m) => {
        return outputMessage(_, m, errorCounter);
    });
}
async function autorestInit(title = 'API-NAME', inputs = ['LIST INPUT FILES HERE']) {
    const cwdUri = uri_1.CreateFolderUri(path_1.resolve());
    for (let i = 0; i < inputs.length; ++i) {
        try {
            inputs[i] = uri_1.MakeRelativeUri(cwdUri, inputs[i]);
        }
        catch (e) { }
    }
    console.log(`# ${title}
> see https://aka.ms/autorest

This is the AutoRest configuration file for the ${title}.

---
## Getting Started
To build the SDK for ${title}, simply [Install AutoRest](https://aka.ms/autorest/install) and in this folder, run:

> ~autorest~

To see additional help and options, run:

> ~autorest --help~
---

## Configuration for generating APIs

...insert-some-meanigful-notes-here...

---
#### Basic Information
These are the global settings for the API.

~~~ yaml
# list all the input OpenAPI files (may be YAML, JSON, or Literate- OpenAPI markdown)
input-file:
${inputs.map(x => '  - ' + x).join('\n')}
~~~

---
#### Language-specific settings: CSharp

These settings apply only when ~--csharp~ is specified on the command line.

~~~ yaml $(csharp)
csharp:
  # override the default output folder
  output-folder: generated/csharp
~~~
`.replace(/~/g, '`'));
}
let exitcode = 0;
let args;
async function currentMain(autorestArgs) {
    if (autorestArgs[0] === 'init') {
        await autorestInit();
        return 0;
    }
    // add probes for readme.*.md files when a standalone arg is given.
    const more = new Array();
    for (const each of autorestArgs) {
        const match = /^--([^=:]+)([=:](.+))?$/g.exec(each);
        if (match && !match[3]) {
            // it's a solitary --foo (ie, no specified value) argument
            more.push(`--try-require=readme.${match[1]}.md`);
        }
    }
    // parse the args from the command line
    args = parseArgs([...autorestArgs, ...more]);
    if ((!args.rawSwitches['message-format']) || args.rawSwitches['message-format'] === 'regular') {
        console.log(color(`> Loading AutoRest core      '${__dirname}' (${require('../package.json').version})`));
    }
    verbose = verbose || args.rawSwitches['verbose'];
    debug = debug || args.rawSwitches['debug'];
    // identify where we are starting from.
    const currentDirUri = uri_1.CreateFolderUri(path_1.resolve());
    // get an instance of AutoRest and add the command line switches to the configuration.
    const api = new autorest_core_1.AutoRest(new datastore_2.EnhancedFileSystem(configuration_1.MergeConfigurations(...args.switches)['github-auth-token'] || process.env.GITHUB_AUTH_TOKEN), uri_1.ResolveUri(currentDirUri, args.configFileOrFolder || '.'));
    api.AddConfiguration(args.switches);
    // listen for output messages and file writes
    subscribeMessages(api, () => exitcode++);
    const artifacts = [];
    const clearFolders = [];
    api.GeneratedFile.Subscribe((_, artifact) => artifacts.push(artifact));
    api.ClearFolder.Subscribe((_, folder) => clearFolders.push(folder));
    const config = (await api.view);
    // maybe a resource schema batch process
    if (config['resource-schema-batch']) {
        return resourceSchemaBatch(api);
    }
    if (config['batch']) {
        await batch(api);
    }
    else {
        const result = await api.Process().finish;
        if (result !== true) {
            throw result;
        }
    }
    if (config.HelpRequested) {
        // no fs operations on --help! Instead, format and print artifacts to console.
        // - print boilerplate help
        console.log('');
        console.log('');
        console.log(color('**Usage**: autorest `[configuration-file.md] [...options]`'));
        console.log('');
        console.log(color('  See: https://aka.ms/autorest/cli for additional documentation'));
        // - sort artifacts by name (then content, just for stability)
        const helpArtifacts = artifacts.sort((a, b) => a.uri === b.uri ? (a.content > b.content ? 1 : -1) : (a.uri > b.uri ? 1 : -1));
        // - format and print
        for (const helpArtifact of helpArtifacts) {
            const help = datastore_4.Parse(helpArtifact.content, (message, index) => console.error(color(`!Parsing error at **${helpArtifact.uri}**:__${index}: ${message}__`)));
            if (!help) {
                continue;
            }
            const activatedBySuffix = help.activationScope ? ` (activated by --${help.activationScope})` : '';
            console.log('');
            console.log(color(`### ${help.categoryFriendlyName}${activatedBySuffix}`));
            if (help.description) {
                console.log(color(help.description));
            }
            console.log('');
            for (const settingHelp of help.settings) {
                const keyPart = `--${settingHelp.key}`;
                const typePart = settingHelp.type ? `=<${settingHelp.type}>` : ` `; // `[=<boolean>]`;
                const settingPart = `${keyPart}\`${typePart}\``;
                // if (!settingHelp.required) {
                //   settingPart = `[${settingPart}]`;
                // }
                console.log(color(`  ${settingPart.padEnd(30)}  **${settingHelp.description}**`));
            }
        }
    }
    else {
        // perform file system operations.
        for (const folder of clearFolders) {
            try {
                await uri_1.ClearFolder(folder);
            }
            catch (e) { }
        }
        for (const artifact of artifacts) {
            await uri_1.WriteString(artifact.uri, artifact.content);
        }
    }
    // return the exit code to the caller.
    return exitcode;
}
function shallowMerge(existing, more) {
    if (existing && more) {
        for (const key of Object.getOwnPropertyNames(more)) {
            const value = more[key];
            if (value !== undefined) {
                /* if (existing[key]) {
                  Console.Log(color(`> Warning: ${key} is overwritten.`));
                } */
                existing[key] = value;
            }
        }
        return existing;
    }
    if (existing) {
        return existing;
    }
    return more;
}
function getRds(schema, path) {
    const rx = /.*\/(.*)\/(.*).json/;
    const m = rx.exec(path) || [];
    const apiversion = m[1];
    const namespace = m[2];
    const result = new Array();
    if (schema.resourceDefinitions) {
        for (const name of Object.getOwnPropertyNames(schema.resourceDefinitions)) {
            result.push(`{ "$ref": "https://schema.management.azure.com/schemas/${apiversion}/${namespace}.json#/resourceDefinitions/${name}" }, `);
        }
    }
    return result;
}
async function resourceSchemaBatch(api) {
    // get the configuration
    const outputs = new Map();
    const schemas = new Array();
    let outstanding = Promise.resolve();
    // ask for the view without
    const config = await api.RegenerateView();
    for (const batchConfig of config.GetNestedConfiguration('resource-schema-batch')) { // really, there should be only one
        for (const eachFile of batchConfig['input-file']) {
            const path = uri_1.ResolveUri(config.configFileFolderUri, eachFile);
            const content = await uri_1.ReadUri(path);
            if (!await autorest_core_1.IsOpenApiDocument(content)) {
                exitcode++;
                console.error(color(`!File ${path} is not a OpenAPI file.`));
                continue;
            }
            // Create the autorest instance for that item
            const instance = new autorest_core_1.AutoRest(new datastore_2.RealFileSystem(), config.configFileFolderUri);
            instance.GeneratedFile.Subscribe((_, file) => {
                if (file.uri.endsWith('.json')) {
                    const more = JSON.parse(file.content);
                    if (!outputs.has(file.uri)) {
                        // Console.Log(`  Writing  *${file.uri}*`);
                        outputs.set(file.uri, file.content);
                        outstanding = outstanding.then(() => uri_1.WriteString(file.uri, file.content));
                        schemas.push(...getRds(more, file.uri));
                        return;
                    }
                    else {
                        const existing = JSON.parse(outputs.get(file.uri));
                        // Console.Log(`  Updating *${file.uri}*`);
                        schemas.push(...getRds(more, file.uri));
                        existing.resourceDefinitions = shallowMerge(existing.resourceDefinitions, more.resourceDefinitions);
                        existing.definitions = shallowMerge(existing.definitions, more.definitions);
                        const content = JSON.stringify(existing, null, 2);
                        outputs.set(file.uri, content);
                        outstanding = outstanding.then(() => uri_1.WriteString(file.uri, content));
                    }
                }
            });
            subscribeMessages(instance, () => exitcode++);
            // set configuration for that item
            instance.AddConfiguration(merging_1.ShallowCopy(batchConfig, 'input-file'));
            instance.AddConfiguration({ 'input-file': eachFile });
            console.log(`Running autorest for *${path}* `);
            // ok, kick off the process for that one.
            await instance.Process().finish.then(async (result) => {
                if (result !== true) {
                    exitcode++;
                    throw result;
                }
            });
        }
    }
    await outstanding;
    return exitcode;
}
async function batch(api) {
    const config = await api.view;
    const batchTaskConfigReference = {};
    api.AddConfiguration(batchTaskConfigReference);
    for (const batchTaskConfig of config.GetEntry('batch')) {
        outputMessage(api, {
            Channel: message_1.Channel.Information,
            Text: `Processing batch task - ${JSON.stringify(batchTaskConfig)} .`
        }, () => { });
        // update batch task config section
        for (const key of Object.keys(batchTaskConfigReference)) {
            delete batchTaskConfigReference[key];
        }
        Object.assign(batchTaskConfigReference, batchTaskConfig);
        api.Invalidate();
        const result = await api.Process().finish;
        if (result !== true) {
            outputMessage(api, {
                Channel: message_1.Channel.Error,
                Text: `Failure during batch task - ${JSON.stringify(batchTaskConfig)} -- ${result}.`
            }, () => { });
            throw result;
        }
    }
}
/**
 * Entry point
 */
async function mainImpl() {
    let autorestArgs = [];
    const exitcode = 0;
    try {
        autorestArgs = process.argv.slice(2);
        if (legacyCli_1.isLegacy(autorestArgs)) {
            return await legacyMain(autorestArgs);
        }
        else {
            return await currentMain(autorestArgs);
        }
    }
    catch (e) {
        // be very careful about the following check:
        // - doing the inversion (instanceof Error) doesn't reliably work since that seems to return false on Errors marshalled from safeEval
        if (e instanceof exception_1.Exception) {
            if (autorestArgs.indexOf('--debug') !== -1) {
                console.log(e);
            }
            else {
                console.log(e.message);
            }
            return e.exitCode;
        }
        if (e !== false) {
            console.error(color(`!${e}`));
        }
    }
    return 1;
}
async function main() {
    let exitcode = 0;
    try {
        exitcode = await mainImpl();
    }
    catch (_a) {
        exitcode = 102;
    }
    finally {
        try {
            await autorest_core_1.Shutdown();
        }
        catch (_b) {
        }
        finally {
            process.exit(exitcode);
        }
    }
}
main();
//# sourceMappingURL=app.js.map