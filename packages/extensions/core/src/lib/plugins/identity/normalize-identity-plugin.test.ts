import { createDataHandle } from "@autorest/test-utils";
import { CancellationTokenSource, DataHandle, DataSink, DataStore, QuickDataSource } from "@azure-tools/datastore";
import { AutorestContext } from "../../context";
import { createNormalizeIdentityPlugin } from "./normalize-identity-plugin";

describe("NormalizeIdentityPlugin", () => {
  const plugin = createNormalizeIdentityPlugin();
  let context: AutorestContext;
  let sink: DataSink;

  const file1 = createDataHandle("{}", { name: "single/file/foo.json" });

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

  it("keeps only the filename if there is a single file", async () => {
    const result = await runPlugin([file1]);
    expect(result).toHaveLength(1);
    expect(result[0].Description).toEqual("foo.json");
  });

  it("finds the common ancestor to files and update file uri to be relative to it", async () => {
    const result = await runPlugin([
      createDataHandle("{}", { name: "myproject/project1/main.json" }),
      createDataHandle("{}", { name: "myproject/project2/data.json" }),
      createDataHandle("{}", { name: "myproject/shared/common.json" }),
    ]);
    expect(result).toHaveLength(3);
    expect(result[0].Description).toEqual("project1/main.json");
    expect(result[1].Description).toEqual("project2/data.json");
    expect(result[2].Description).toEqual("shared/common.json");
  });

  it("finds the common ancestor to files and update file uri to be relative to it when using urls", async () => {
    const result = await runPlugin([
      createDataHandle("{}", { name: "https://github.com/myorg/myproject/project1/main.json" }),
      createDataHandle("{}", { name: "https://github.com/myorg/myproject/project2/data.json" }),
      createDataHandle("{}", { name: "https://github.com/myorg/myproject/shared/common.json" }),
    ]);
    expect(result).toHaveLength(3);
    expect(result[0].Description).toEqual("project1/main.json");
    expect(result[1].Description).toEqual("project2/data.json");
    expect(result[2].Description).toEqual("shared/common.json");
  });

  it("update refs accordingly", async () => {
    const mainContent = {
      definitions: {
        $ref: "https://github.com/myorg/myproject/project2/data.json#/foo",
      },
    };
    const result = await runPlugin([
      createDataHandle(JSON.stringify(mainContent), { name: "https://github.com/myorg/myproject/project1/main.json" }),
      createDataHandle(`{"foo": "bar"}`, { name: "https://github.com/myorg/myproject/project2/data.json" }),
    ]);
    expect(result).toHaveLength(2);
    const data = await result[0].ReadObject<typeof mainContent>();
    expect(data.definitions.$ref).toEqual("../project2/data.json#/foo");
  });
});
