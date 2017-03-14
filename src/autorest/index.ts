import { Installer } from "./installer"
export { Installer } from "./installer";
import { join } from 'path';
require("./lib/polyfill.min.js")

// required  it by this time. 
export { IFileSystem, Message, AutoRest as IAutoRest } from 'autorest-core';
export const AutoRest = Installer.AutorestImplementation;
