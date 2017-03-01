import { AutoRest as autorest_interface } from "autorest-app"
import { Installer } from "./installer"
export { Installer } from "./installer";
import { join } from 'path';

// required  it by this time. 
export { IFileSystem } from 'autorest-app'

export const AutoRest: autorest_interface = require(join(Installer.AutorestFolder, this.version, 'node_modules', 'autorest-app'));