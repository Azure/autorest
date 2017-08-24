import * as cp from 'child_process';
import * as rpc from 'vscode-jsonrpc';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";


async function connect() {
  let childProcess = cp.spawn("dotnet", [`${__dirname}/../../../core/AutoRest/bin/netcoreapp1.0/AutoRest.dll`, "--server"]);

  // Use stdin and stdout for communication:
  let connection = rpc.createMessageConnection(
    new rpc.StreamMessageReader(childProcess.stdout),
    new rpc.StreamMessageWriter(childProcess.stdin), console);

  // host interface
  connection.onNotification(new rpc.NotificationType4<string, string, string, any, void>('WriteFile'), (sessionId: string, filename: string, content: string, sourcemap: any) => {
    console.log(`Saving File ${sessionId}, ${filename}`);
  });

  connection.onNotification(new rpc.NotificationType3<string, any, any, void>('Message'), (sessionId: string, details: any, sourcemap: any) => {
    console.log(`You have posted message ${sessionId}, ${details}`);
  });

  connection.onRequest(new rpc.RequestType2<string, string, string, void, void>('ReadFile'), (sessionId: string, filename: string) => {
    return `You asked for the file ${filename} in the session ${sessionId}`;
  });

  connection.onRequest(new rpc.RequestType2<string, string, string, void, void>('GetValue'), (sessionId: string, key: string) => {
    return `You asked for the value ${key} in the session ${sessionId}`;
  });

  connection.onRequest(new rpc.RequestType1<string, Array<string>, void, void>('ListInputs'), (sessionId: string) => {
    return ["a.txt", "b.txt"];
  });

  // extension interface
  let EnumeratePlugins = new rpc.RequestType0<Array<string>, void, void>('GetPluginNames');
  let Process = (plugin: string, session: string) => connection.sendRequest(new rpc.RequestType2<string, string, boolean, void, void>('Process'), plugin, session);
  let Shutdown = () => connection.sendNotification(new rpc.NotificationType0<void>('Shutdown'));

  childProcess.stderr.pipe(process.stdout);
  connection.listen();

  console.log('before enumerate')
  let values = await connection.sendRequest(EnumeratePlugins);
  for (let each of values) {
    console.log(each);
  }
  console.log('after enumerate')

  console.log('calling process')
  let result = await Process("Modeler", "session1");
  console.log(`done process: ${result} `)

  Shutdown();

  // wait for shutdown!
  await new Promise((resolve) => {
    setTimeout(() => {
      resolve();
    }, 200);
  });

}

@suite class TestConnectivity {
  @test @timeout(10000) async "E2E"() {
    await connect();
  }
}

