import { createDataHandle } from "@autorest/test-utils";
import { CancellationTokenSource, DataHandle, DataSink, DataStore, QuickDataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { createIdentityResetPlugin } from "./reset-identity-plugin";

describe("ResetIdentityPlugin", () => {
  const plugin = createIdentityResetPlugin();
  let context: AutorestContext;
  let sink: DataSink;

  const file1 = createDataHandle("foo", { name: "foo.json" });
  const file2 = createDataHandle("foo", { name: "bar.json" });

  beforeEach(() => {
    context = {
      config: {},
    } as any;
    const cts: CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new DataStore(cts.token);
    sink = ds.getDataSink();
  });

  const runPlugin = async (files: DataHandle[]): Promise<DataHandle[]> => {
    const source = new QuickDataSource(files);
    const result = await plugin(context, source, sink);
    const results = await result.Enum();

    return Promise.all(results.map((x) => result.ReadStrict(x)));
  };

  it("keeps the same name if there is a single file only.", async () => {
    const files = await runPlugin([file1]);
    expect(files).toHaveLength(1);
    expect(files[0]?.Description).toEqual("mem://foo.json");
  });

  it("adds an id counter suffix to the filename if there are multiple.", async () => {
    const files = await runPlugin([file1, file2]);
    expect(files).toHaveLength(2);

    expect(files[0]?.Description).toEqual("mem://foo-0.json");
    expect(files[1]?.Description).toEqual("mem://bar-1.json");
  });

  it("rename the files if a name is being passed", async () => {
    context.config.name = "renamed-file.json";
    const files = await runPlugin([file1, file2]);
    expect(files).toHaveLength(2);
    expect(files[0]?.Description).toEqual("renamed-file-0.json");
    expect(files[1]?.Description).toEqual("renamed-file-1.json");
  });
});
