import { EventEmitter, IEvent } from '../autorest-core/lib/events';
import { DocumentPatterns } from '../autorest-core/lib/document-type';
// polyfill for the AsyncIterator support
if (!Symbol.asyncIterator) {
  require("./lib/polyfill.min.js")
}

// exports the public AutoRest definitions
export { Installer } from "./installer";
export { IFileSystem, Message, AutoRest as IAutoRest, DocumentType, DocumentExtension, DocumentPatterns } from 'autorest-core';
export { EventEmitter, IEvent } from '../autorest-core/lib/events';

// the local class definition of the AutoRest Interface
import { AutoRest as IAutoRest } from 'autorest-core';

// export the selected implementation of the AutoRest interface.
import { Installer } from "./installer"

let modulePath = /(\\||\/)src(\\||\/)autorest(\\||\/)/.test(__dirname) ? `${__dirname}/../autorest-core` : Installer.AutorestImplementationPath
let impl = require(modulePath);

export const AutoRest: typeof IAutoRest = <typeof IAutoRest><any>impl.AutoRest
export declare type AutoRest = IAutoRest;
