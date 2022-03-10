/* eslint-disable no-console */
import * as fs from "fs";
import * as os from "os";
import * as asyncio from "@azure-tools/async-io";
import * as tasks from "@azure-tools/tasks";
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
        const installing = extensionManager.installPackage(dni, false, 60000, (i) => {});
        const extension = await installing;
        expect(await extension.configuration).not.toEqual("the configuration file isnt where it should be?");
      }

      {
        console.log("Attempt Overwrite");
        // install/overwrite
        const dni = await extensionManager.findPackage("echo-cli", "*");
        const installing = extensionManager.installPackage(dni, true, 60000, (i) => {});

        // install at the same time?
        const dni2 = await extensionManager.findPackage("echo-cli", "*");
        const installing2 = extensionManager.installPackage(dni2, true, 60000, (i) => {});

        // wait for it.
        const extension = await installing;
        expect(await extension.configuration).not.toEqual("");

        const extension2 = await installing2;
        expect(await extension2.configuration).not.toEqual("");

        let done = false;
        for (const each of await extensionManager.getInstalledExtensions()) {
          done = true;
          // make sure we have one extension installed and that it is echo-cli (for testing)
          expect(each.name).toEqual("echo-cli");
        }

        expect(done).toBe(true);
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
      expect(p.name).toEqual("autorest");
    },
    TEST_TIMEOUT,
  );

  it(
    "FindPackage- unknown package",
    async () => {
      await expect(async () => {
        await extensionManager.findPackage("koooopasdpasdppasdpa");
      }).rejects.toThrowError(UnresolvedPackageException);
    },
    TEST_TIMEOUT,
  );

  it(
    "BadPackageID- garbage name",
    async () => {
      await expect(async () => {
        await extensionManager.findPackage("LLLLl", "$DDFOIDFJIODFJ");
      }).rejects.toThrowError(InvalidPackageIdentityException);
    },
    TEST_TIMEOUT,
  );

  it("View Versions", async () => {
    // gets a package
    const pkg = await extensionManager.findPackage("echo-cli");
    // finds out if there are more versions
    expect((await pkg.allVersions).length > 5).toBe(true);
  });

  it(
    "Install Extension",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "1.0.8");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {});

      const extension = await installing;

      expect(await extension.configuration).not.toEqual("");

      let done = false;

      for (const each of await extensionManager.getInstalledExtensions()) {
        done = true;
        // make sure we have one extension installed and that it is echo-cli (for testing)
        expect(each.name).toEqual("echo-cli");
      }

      expect(done).toBe(true);
    },
    TEST_TIMEOUT,
  );

  it(
    "Install Extension via star",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "*");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {});
      const extension = await installing;

      expect(await extension.configuration).not.toEqual("");

      let done = false;

      for (const each of await extensionManager.getInstalledExtensions()) {
        done = true;
        // make sure we have one extension installed and that it is echo-cli (for testing)
        expect(each.name).toEqual("echo-cli");
      }

      expect(done).toBe(true);
    },
    TEST_TIMEOUT,
  );

  it(
    "Force install",
    async () => {
      const dni = await extensionManager.findPackage("echo-cli", "*");
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {});
      const extension = await installing;
      expect(await extension.configuration).not.toEqual("");

      // erase the readme.md file in the installed folder (check if force works to reinstall)
      await asyncio.rmFile(await extension.configurationPath);

      // reinstall with force!
      const installing2 = extensionManager.installPackage(dni, true, 5 * 60 * 1000, (installing) => {});
      const extension2 = await installing2;

      // is the file back?
      expect(await extension2.configuration).not.toEqual("");
    },
    TEST_TIMEOUT,
  );

  it.only(
    "Test Start",
    async () => {
      const dni = await extensionManager.findPackage("none", "fearthecowboy/echo-cli");
      console.log("DNI", dni);
      const installing = extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {});
      const extension = await installing;
      expect(await extension.configuration).toEqual("");
      const proc = await extension.start();
      await tasks.When(proc, "exit");
    },
    TEST_TIMEOUT,
  );
});
