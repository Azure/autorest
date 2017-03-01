import { AutoRest as autorest_interface } from "./autorest"
import { Installer } from "./installer"
export { Installer } from "./installer";
import { join } from 'path';

// required  it by this time. 

export const AutoRest: autorest_interface = require(join(Installer.AutorestFolder, this.version, 'node_modules', 'autorest-app'));


