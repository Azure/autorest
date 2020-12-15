import * as cp from "child_process";
import * as rpc from "vscode-jsonrpc";

async function connect() {
  const childProcess = cp.spawn("dotnet", [
    `${__dirname}/../../../core/AutoRest/bin/netcoreapp1.0/AutoRest.dll`,
    "--server",
  ]);

  // Use stdin and stdout for communication:
  const connection = rpc.createMessageConnection(
    new rpc.StreamMessageReader(childProcess.stdout),
    new rpc.StreamMessageWriter(childProcess.stdin),
    console,
  );

  // host interface
  connection.onNotification(
    new rpc.NotificationType4<string, string, string, any, void>("WriteFile"),
    (sessionId: string, filename: string, content: string, sourcemap: any) => {
      console.log(`Saving File ${sessionId}, ${filename}`);
    },
  );

  connection.onNotification(
    new rpc.NotificationType3<string, any, any, void>("Message"),
    (sessionId: string, details: any, sourcemap: any) => {
      console.log(`You have posted message ${sessionId}, ${details}`);
    },
  );

  connection.onRequest(
    new rpc.RequestType2<string, string, string, void, void>("ReadFile"),
    (sessionId: string, filename: string) => {
      return `You asked for the file ${filename} in the session ${sessionId}`;
    },
  );

  connection.onRequest(
    new rpc.RequestType2<string, string, string, void, void>("GetValue"),
    (sessionId: string, key: string) => {
      return `You asked for the value ${key} in the session ${sessionId}`;
    },
  );

  connection.onRequest(
    new rpc.RequestType2<string, string | undefined, Array<string>, void, void>("ListInputs"),
    (sessionId: string) => {
      return ["a.txt", "b.txt"];
    },
  );

  // extension interface
  const EnumeratePlugins = new rpc.RequestType0<Array<string>, void, void>("GetPluginNames");
  const Process = (plugin: string, session: string) =>
    connection.sendRequest(new rpc.RequestType2<string, string, boolean, void, void>("Process"), plugin, session);
  const Shutdown = () => connection.sendNotification(new rpc.NotificationType0<void>("Shutdown"));

  childProcess.stderr.pipe(process.stdout);
  connection.listen();

  console.log("before enumerate");
  const values = await connection.sendRequest(EnumeratePlugins);
  for (const each of values) {
    console.log(each);
  }
  console.log("after enumerate");

  console.log("calling process");
  const result = await Process("Modeler", "session1");
  console.log(`done process: ${result} `);

  Shutdown();

  // wait for shutdown!
  await new Promise<void>((resolve) => {
    setTimeout(() => {
      resolve();
    }, 200);
  });
}

describe("TestConnectivity", () => {
  xit("E2E", async () => {
    await connect();
  });
});
