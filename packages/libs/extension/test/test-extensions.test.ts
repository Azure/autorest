/* eslint-disable no-console */
import * as asyncio from "@azure-tools/async-io";
import * as tasks from "@azure-tools/tasks";
import assert from "assert";
import * as fs from "fs";
import * as os from "os";
import { ExtensionManager, InvalidPackageIdentityException, UnresolvedPackageException } from "../src";

const tmpFolder = fs.mkdtempSync(`${fs.mkdtempSync(`${os.tmpdir()}/test`)}/install-pkg`);

// Those test do install pacakge and could take a little bit of time. Increasing timeout to 50s.
const TEST_TIMEOUT = 50_000;

describe("TestExtensions", () => {
  let extensionManager: ExtensionManager;
  beforeEach(async () => {
    extensionManager = await ExtensionManager.Create(tmpFolder);
  });

  afterEach(async () => {
    try {
      await extensionManager.dispose();
      try {
        await tasks.Delay(500);
        await asyncio.rmdir(tmpFolder);
      } catch (E) {
        console.error("rmdir is giving grief... [probably intermittent]");
      }
    } catch (e) {
      console.error("ABORTING\n");
      console.error(e);
      throw "AFTER TEST ABORTED";
    }
  });

  it(
    "reset",
    async () => {
      await extensionManager.reset();
      {
        console.log("Installing Once");
        // install it once
        const dni = await extensionManager.findPackage("echo-cli", "*");
        const installing = extensionManager.installPackage(dni, false, 60000, (i) =>
          i.Message.Subscribe((s, m) => {
            console.log(`Installer:${m}`);
          }),
        );
        const extension = await installing;
        assert.notEqual(await extension.configuration, "the configuration file isnt where it should be?");
      }

      {
        console.log("Attempt Overwrite");
        // install/overwrite
        const dni = await extensionManager.findPackage("echo-cli", "*");
        const installing = extensionManager.installPackage(dni, true, 60000, (i) =>
          i.Message.Subscribe((s, m) => {
            console.log(`Installer2:${m}`);
          }),
        );

        // install at the same time?
        const dni2 = await extensionManager.findPackage("echo-cli", "*");
        const installing2 = extensionManager.installPackage(dni2, true, 60000, (i) =>
          i.Message.Subscribe((s, m) => {
            console.log(`Installer3:${m}`);
          }),
        );

        // wait for it.
        const extension = await installing;
        assert.notEqual(await extension.configuration, "");

        const extension2 = await installing2;
        assert.notEqual(await extension.configuration, "");

        let done = false;
        for (const each of await extensionManager.getInstalledExtensions()) {
          done = true;
          // make sure we have one extension installed and that it is echo-cli (for testing)
          assert.equal(each.name, "echo-cli");
        }

        assert.equal(done, true, "Package is not installed");
        //await tasks.Delay(5000);
      }
    },
    TEST_TIMEOUT,
  );

  /*
  @test async 'FindPackage- in github'() {
    // github repo style
    const npmpkg = await extensionManager.findPackage('npm', 'npm/npm');
    assert.equal(npmpkg.name, 'npm');
  }
  */

  it(
    "FindPackage- in npm",
    async () => {
      const p = await extensionManager.findPackage("autorest");
      assert.equal(p.name, "autorest");
    },
    TEST_TIMEOUT,
  );

  it(
    "FindPackage- unknown package",
    async () => {
      let threw = false;
      try {
        const p = await extensionManager.findPackage("koooopasdpasdppasdpa");
      } catch (e) {
        if (e instanceof UnresolvedPackageException) {
          threw = true;
        }
      }
      assert.equal(threw, true, "Expected unknown package to throw UnresolvedPackageException");
    },
    TEST_TIMEOUT,
  );

  it(
    "BadPackageID- garbage name",
    async () => {
      let threw = false;
      try {
        await extensionManager.findPackage("LLLLl", "$DDFOIDFJIODFJ");
      } catch (e) {
        if (e instanceof InvalidPackageIdentityException) {
          threw = true;
        }
      }
      assert.equal(threw, true, "Expected bad package id to throw InvalidPackageIdentityException");
    },
    TEST_TIMEOUT,
  );

  it("View Versions", async () => {
    // gets a package
    const pkg = await extensionManager.findPackage("echo-cli");
    // finds out if there are more versions
    assert.equal((await pkg.allVersions).length > 5, true);
  });

  it(
    "Install Extension",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "1.0.8");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
        installing.Message.Subscribe((s, m) => {
          console.log(`Installer:${m}`);
        });
      });

      const extension = await installing;

      assert.notEqual(await extension.configuration, "");

      let done = false;

      for (const each of await extensionManager.getInstalledExtensions()) {
        done = true;
        // make sure we have one extension installed and that it is echo-cli (for testing)
        assert.equal(each.name, "echo-cli");
      }

      assert.equal(done, true, "Package is not installed");
    },
    TEST_TIMEOUT,
  );

  it(
    "Install Extension via star",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "*");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
        installing.Message.Subscribe((s, m) => {
          console.log(`Installer:${m}`);
        });
      });
      const extension = await installing;

      assert.notEqual(await extension.configuration, "");

      let done = false;

      for (const each of await extensionManager.getInstalledExtensions()) {
        done = true;
        // make sure we have one extension installed and that it is echo-cli (for testing)
        assert.equal(each.name, "echo-cli");
      }

      assert.equal(done, true, "Package is not installed");
    },
    TEST_TIMEOUT,
  );

  it(
    "Force install",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "*");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
        installing.Message.Subscribe((s, m) => {
          console.log(`Installer:${m}`);
        });
      });
      const extension = await installing;
      assert.notEqual(await extension.configuration, "");

      // erase the readme.md file in the installed folder (check if force works to reinstall)
      await asyncio.rmFile(await extension.configurationPath);

      // reinstall with force!
      const installing2 = extensionManager.installPackage(dni, true, 5 * 60 * 1000, (installing) => {
        installing.Message.Subscribe((s, m) => {
          console.log(`Installer:${m}`);
        });
      });
      const extension2 = await installing2;

      // is the file back?
      assert.notEqual(await extension2.configuration, "");
    },
    TEST_TIMEOUT,
  );

  it(
    "Test Start",
    async () => {
      try {
        const dni = await extensionManager.findPackage("none", "fearthecowboy/echo-cli");
        const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
          installing.Message.Subscribe((s, m) => {
            console.log(`Installer:${m}`);
          });
        });
        const extension = await installing;
        assert.notEqual(await extension.configuration, "");
        const proc = await extension.start();
        await tasks.When(proc, "exit");
      } catch (E) {
        // oh well...
        console.error(E);
        assert(false, "FAILED DURING START TEST.");
      }
    },
    TEST_TIMEOUT,
  );
});
