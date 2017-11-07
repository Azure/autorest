fs = require("fs");
gen = require('./node_modules/dts-generator/').default

async function main() {
  await gen({
      name: 'autorest-core',

      baseDir: './',
      exclude: ['test/**/*','node_modules/**/*.d.ts',
//'lib/artifact.ts',
//'lib/autorest-core.ts',
// 'lib/configuration.ts',
'lib/constants.ts',
//'lib/document-type.ts',
// 'lib/events.ts',    
'lib/exception.ts',
// 'lib/file-system.ts',
'lib/lazy.ts',
//'lib/message.ts',
'lib/outstanding-task-awaiter.ts',
'lib/sleep.ts',
'lib/data-store/data-store.ts',
'lib/parsing/literate-yaml.ts',
'lib/parsing/literate.ts',
'lib/parsing/stable-object.ts',
'lib/parsing/text-utility.ts',
'lib/parsing/yaml.ts',
'lib/pipeline/artifact-emitter.ts',
'lib/pipeline/commonmark-documentation.ts',
'lib/pipeline/manipulation.ts',
'lib/pipeline/object-manipulator.ts',
'lib/pipeline/pipeline.ts',
'lib/pipeline/plugin-api.ts',
'lib/pipeline/plugin-endpoint.ts',
'lib/pipeline/suppression.ts',
'lib/pipeline/swagger-loader.ts',
'lib/ref/async.ts',
'lib/ref/cancellation.ts',
'lib/ref/commonmark.ts',
// 'lib/ref/jsonpath.ts',
'lib/ref/jsonrpc.ts',
'lib/ref/linq.ts',
'lib/ref/safe-eval.ts',
//'lib/ref/source-map.ts',
'lib/ref/uri.ts',
'lib/ref/yaml.ts',
'lib/source-map/blaming.ts',
'lib/source-map/merging.ts',
'lib/source-map/source-map.ts',    
    ],
    
    
    
    
      out: './a.d.ts',
      files: ['main.ts', 'lib/file-system.ts']
      
  });
  
  
  
  /* let lsp = fs.readFileSync("vscode-languageserver-protocol.d.ts",'utf8').replace(/'.\//g,"'vscode-languageserver-protocol/").replace("vscode-languageserver-protocol/main","vscode-languageserver-protocol");
  
  let vscj = fs.readFileSync("vscode-jsonrpc.d.ts",'utf8').replace(/'.\//g,"'vscode-jsonrpc/").replace("vscode-jsonrpc/main","vscode-jsonrpc");
  
  
  let client = fs.readFileSync("vscode-languageclient.d.ts",'utf8').replace(/'.\//g,"'vscode-languageclient/").replace("vscode-languageclient/main","vscode-languageclient");
  

  
  let vscode = fs.readFileSync("vscode.d.ts",'utf8');
  
  let lspt = fs.readFileSync("vscode-languageserver-types.d.ts",'utf8').replace("vscode-languageserver-types/main","vscode-languageserver-types");
  
  let f = vscode+ '\n' + vscj + '\n' + client + "\n" + lsp +"\n" + lspt;

  fs.writeFileSync("vscode-languageclient.d.ts", f );  
  */
 
  
  

  await gen({
      name: 'foo-core',

      baseDir: './dist',
      exclude: ['test/**/*','node_modules/**/*.d.ts' ],
     out: './b.d.ts',
    files: ['main.d.ts']
    
  });
  
  
}

main();