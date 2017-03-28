import { DocumentPatterns } from '../autorest-core/lib/document-type';
// polyfill for the AsyncIterator support
if (!Symbol.asyncIterator) {
  require("./lib/polyfill.min.js")
}

// exports the public AutoRest definitions
export { Installer } from "./installer";
export { IEvent } from '../autorest-core/lib/events';
export { IFileSystem, Message } from 'autorest-core';
export { Asset, Release, Github } from './github'

// the local class definition of the AutoRest Interface and the EventEmitter signatures
import { AutoRest as IAutoRest } from 'autorest-core';
import { EventEmitter as IEventEmitter } from '../autorest-core/lib/events';

// export the selected implementation of the AutoRest interface.
import { Installer } from "./installer"

let modulePath = /(\\||\/)src(\\||\/)autorest(\\||\/)/.test(__dirname) ? `${__dirname}/../autorest-core` : Installer.AutorestImplementationPath
let impl = require(modulePath);

export const AutoRest: typeof IAutoRest = <typeof IAutoRest><any>impl.AutoRest
export declare type AutoRest = IAutoRest;

let event_impl = require(modulePath + "/lib/events");
export const EventEmitter: typeof IEventEmitter = <typeof IEventEmitter><any>event_impl.EventEmitter
export declare type EventEmitter = IEventEmitter;
