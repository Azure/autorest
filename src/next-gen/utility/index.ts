import * as shelljs from 'shelljs';
import {PlatformInformation} from './platform'

class ExecResult {
  exitCode : number;
  stdout : string;
  stderr : string;
}

export class Utility {

  static async exec(cmdline:string, ):Promise<ExecResult> {
    return new Promise<ExecResult>( (resolve, reject) => {
      shelljs.exec(cmdline,{async: true, silent: true}, (code,stdout,stderr)=> {
        resolve({
          exitCode: code,
          stdout : stdout,
          stderr : stderr
        });
      });
    }); 
  }

  static async PlatformInformation():Promise<PlatformInformation> {
    return PlatformInformation.GetCurrent();
  }

  
}