import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";
import { IFileSystem, MemoryFileSystem } from "../lib/file-system"
import * as AutoRest from "../lib/autorest-core"

@suite class TestConfiguration {

  @test async "Test config"() {
    // test out subscribe

    let f = new MemoryFileSystem(new Map<string, string>([
      ['readme.md', `
# this is a test
 see https://aka.ms/autorest
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
`],
      ['other.md', `
# My Doc.

# some text

`]]));

    const autorest = new AutoRest.AutoRest(f, MemoryFileSystem.DefaultVirtualRootUri + "readme.md");
    autorest.AddConfiguration({ "use-extension": { "@microsoft.azure/autorest-classic-generators": `${__dirname}/../../../core/AutoRest` } })
    let cfg = await autorest.view;

    // console.log(cfg.Raw);

    // output folder should be 'foo'
    assert.equal(cfg['output-folder'], "foo");

    // my-value should not get resolved here because the dependent variable is after
    assert.equal(cfg['my-value'], '$(sample-value)');

    // sample-other should get resolved to the value of sample-value
    assert.equal(cfg['sample-other'], 'one');

    // verify that the items object that uses a macro works too
    assert.equal(cfg['items'][3], "one/two");

    for (const each of cfg.GetNestedConfiguration("csharp")) {
      // console.log(each.Raw);

      // verify the output folder is relative
      assert.equal(each.GetEntry('output-folder'), "foo/csharp");

      // verify that the items object that uses a macro works too
      // assert.equal((<any>(each.Raw))['items'][3], "two/two");

      // now, this got resolved alot earlier.
      // dunno if we need it the other way or not.
      assert.equal(each['items'][3], "one/two");
    }

    // override the output-folder from the cmdline
    autorest.AddConfiguration({ "output-folder": "OUTPUT" });
    cfg = await autorest.view;
    assert.equal(cfg['output-folder'], "OUTPUT");

    for (const each of cfg.GetNestedConfiguration("csharp")) {
      assert.equal(each['output-folder'], "OUTPUT/csharp");
    }

  }
}
