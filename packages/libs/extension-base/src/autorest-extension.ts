import { createMessageConnection, RequestType0, RequestType2 } from "vscode-jsonrpc";
import { AutorestExtensionHost, AutorestExtensionRpcHost } from "./extension-host";
import { Channel } from "./types";

namespace IAutoRestPluginTargetTypes {
  export const GetPluginNames = new RequestType0<Array<string>, Error, void>("GetPluginNames");
  export const Process = new RequestType2<string, string, boolean, Error, void>("Process");
}

export type AutoRestPluginHandler = (initiator: AutorestExtensionHost) => Promise<void>;

export class AutoRestExtension {
  private readonly plugins: Record<string, AutoRestPluginHandler> = {};

  public add(name: string, handler: AutoRestPluginHandler): void {
    this.plugins[name] = handler;
  }

  public async run(
    input: NodeJS.ReadableStream = process.stdin,
    output: NodeJS.WritableStream = process.stdout,
  ): Promise<void> {
    // connection setup
    const channel = createMessageConnection(input, output, {
      error(message) {
        // eslint-disable-next-line no-console
        console.error("rpc:error: ", message);
      },
      info(message) {
        // eslint-disable-next-line no-console
        console.error("rpc:info: ", message);
      },
      log(message) {
        // eslint-disable-next-line no-console
        console.error("rpc:log: ", message);
      },
      warn(message) {
        // eslint-disable-next-line no-console
        console.error("rpc:warn: ", message);
      },
    });

    channel.onRequest(IAutoRestPluginTargetTypes.GetPluginNames, async () => Object.keys(this.plugins));
    channel.onRequest(IAutoRestPluginTargetTypes.Process, async (pluginName: string, sessionId: string) => {
      const host = new AutorestExtensionRpcHost(channel, sessionId);

      try {
        const handler = this.plugins[pluginName];
        if (!handler) {
          throw new Error(`Plugin host could not find requested plugin '${pluginName}'.`);
        }
        await handler(host);
        return true;
      } catch (e: any) {
        if (await host.getValue<boolean>("debug")) {
          // eslint-disable-next-line no-console
          console.error(`PLUGIN FAILURE: ${e.message}, ${e.stack}, ${JSON.stringify(e, null, 2)}`);
        }
        host.message({
          Channel: Channel.Fatal,
          Text: "" + e,
          Details: e,
        });
        return false;
      }
    });

    // activate
    channel.listen();
  }

  /**
   * @deprecated Use #add
   */
  public Add(name: string, handler: AutoRestPluginHandler) {
    return this.add(name, handler);
  }
  /**
   * @deprecated Use #run
   */
  public Run(input: NodeJS.ReadableStream = process.stdin, output: NodeJS.WritableStream = process.stdout) {
    return this.run(input, output);
  }
}
