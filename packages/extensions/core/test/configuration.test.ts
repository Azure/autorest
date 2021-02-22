import { AutorestRawConfiguration } from "@autorest/configuration";
import { MemoryFileSystem } from "@azure-tools/datastore";
import * as AutoRest from "../src/lib/autorest-core";

describe("Configuration", () => {
  it("Test config", async () => {
    // test out subscribe

    const f = new MemoryFileSystem(
      new Map<string, string>([
        [
          "readme.md",
          `
# this is a test
> see https://aka.ms/autorest
~~~ yaml
my-value: $(sample-value)
sample-value: one
sample-other: $(sample-value)

input-file:
  - other.md

items:
 - foo
 - bar
 - bin
 - $(sample-value)/two

output-folder: foo

csharp:
  sample-value: two
  output-folder: $(output-folder)/csharp

~~~
`,
        ],
        [
          "other.md",
          `
# My Doc.

# some text

`,
        ],
      ]),
    );

    const autorest = new AutoRest.AutoRest(f, MemoryFileSystem.DefaultVirtualRootUri + "readme.md");
    const context = await autorest.view;
    const cfg = context.config;

    // output folder should be 'foo'
    expect(cfg.raw["output-folder"]).toEqual("foo");

    // sample-other should get resolved to the value of sample-value
    expect(cfg.raw["sample-other" as keyof AutorestRawConfiguration]).toEqual("one");

    // verify that the items object that uses a macro works too
    expect(cfg.raw["items" as keyof AutorestRawConfiguration][3]).toEqual("one/two");

    for (const each of context.getNestedConfiguration("csharp")) {
      // verify the output folder is relative
      expect(each.GetEntry("output-folder")).toEqual("foo/csharp");

      // verify that the items object that uses a macro works too
      // expect((<any>(each.Raw))['items'][3]).toEqual( "two/two");

      // now, this got resolved alot earlier.
      // dunno if we need it the other way or not.
      expect(each.config["items" as keyof AutorestRawConfiguration][3]).toEqual("one/two");
    }

    // override the output-folder from the cmdline
    autorest.AddConfiguration({ "output-folder": "OUTPUT" });
    const updatedContext = await autorest.view;
    expect(updatedContext.config.raw["output-folder"]).toEqual("OUTPUT");

    for (const each of updatedContext.getNestedConfiguration("csharp")) {
      expect(each.config.raw["output-folder"]).toEqual("OUTPUT/csharp");
    }
  });

  it("Test Guards", async () => {
    // test out subscribe
    const f = new MemoryFileSystem(
      new Map<string, string>([
        [
          "readme.md",
          `
# this is a test
> see https://aka.ms/autorest

~~~ yaml $(foo)
value:
 - foo
~~~

~~~ yaml $(foo) && $(bar)
value:
  - foo_and_bar
~~~

~~~ yaml $(foo) && $(bar) === undefined
value:
 - foo_and_not_bar
~~~

~~~ yaml $(bar)
value:
 - bar
~~~

~~~ yaml !$(bar)
value:
 - not_bar
~~~

`,
        ],
        [
          "other.md",
          `
# My Doc.

# some text

`,
        ],
      ]),
    );

    const autorest = new AutoRest.AutoRest(f, MemoryFileSystem.DefaultVirtualRootUri + "readme.md");
    autorest.AddConfiguration({ foo: true });
    let context = await autorest.view;

    // output folder should be 'foo'
    expect(context.config.raw["value" as keyof AutorestRawConfiguration]).toEqual([
      "not_bar",
      "foo_and_not_bar",
      "foo",
    ]);

    autorest.AddConfiguration({ bar: true });
    context = await autorest.view;
    expect(context.config.raw["value" as keyof AutorestRawConfiguration]).toEqual(["bar", "foo_and_bar", "foo"]);
  });
});
