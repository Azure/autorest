import * as asyncio from '@azure-tools/async-io';
import * as tasks from '@azure-tools/tasks';
import * as assert from 'assert';
import * as fs from 'fs';
import { suite, test } from 'mocha-typescript';
import * as os from 'os';
import { ExtensionManager, InvalidPackageIdentityException, UnresolvedPackageException } from '../src/main';

require('source-map-support').install();


@suite class TestExtensions {

  static after() {
    process.exit();
  }
  private tmpFolder = fs.mkdtempSync(`${fs.mkdtempSync(`${os.tmpdir()}/test`)}/install-pkg`);

  extensionManager!: ExtensionManager;

  async before() {
    this.extensionManager = await ExtensionManager.Create(this.tmpFolder);
  }

  async after() {

    try {
      await this.extensionManager.dispose();
      try {
        await tasks.Delay(500);
        await asyncio.rmdir(this.tmpFolder);
      } catch (E) {
        console.error('rmdir is giving grief... [probably intermittent]');
      }
    } catch (e) {
      console.error('ABORTING\n');
      console.error(e);
      throw 'AFTER TEST ABORTED';
    }
  }

  @test async 'Test Reset'() {
    console.log('Resetting');
    await this.extensionManager.reset();
    {
      console.log('Installing Once');
      // install it once
      const dni = await this.extensionManager.findPackage('echo-cli', '*');
      const installing = this.extensionManager.installPackage(dni, false, 60000, (i) => i.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); }));
      const extension = await installing;
      assert.notEqual(await extension.configuration, 'the configuration file isnt where it should be?');
    }

    {

      console.log('Attempt Overwrite');
      // install/overwrite
      const dni = await this.extensionManager.findPackage('echo-cli', '*');
      const installing = this.extensionManager.installPackage(dni, true, 60000, (i) => i.Message.Subscribe((s, m) => { console.log(`Installer2:${m}`); }));

      // install at the same time?
      const dni2 = await this.extensionManager.findPackage('echo-cli', '*');
      const installing2 = this.extensionManager.installPackage(dni2, true, 60000, (i) => i.Message.Subscribe((s, m) => { console.log(`Installer3:${m}`); }));

      // wait for it.
      const extension = await installing;
      assert.notEqual(await extension.configuration, '');

      const extension2 = await installing2;
      assert.notEqual(await extension.configuration, '');

      let done = false;
      for (const each of await this.extensionManager.getInstalledExtensions()) {
        done = true;
        // make sure we have one extension installed and that it is echo-cli (for testing)
        assert.equal(each.name, 'echo-cli');
      }

      assert.equal(done, true, 'Package is not installed');
      //await tasks.Delay(5000);
    }
  }

  /*
  @test async 'FindPackage- in github'() {
    // github repo style
    const npmpkg = await this.extensionManager.findPackage('npm', 'npm/npm');
    assert.equal(npmpkg.name, 'npm');
  }
  */


  @test async 'FindPackage- in npm'() {
    const p = await this.extensionManager.findPackage('autorest');
    assert.equal(p.name, 'autorest');
  }


  @test async 'FindPackage- unknown package'() {
    let threw = false;
    try {
      const p = await this.extensionManager.findPackage('koooopasdpasdppasdpa');
    } catch (e) {
      if (e instanceof UnresolvedPackageException) {
        threw = true;
      }
    }
    assert.equal(threw, true, 'Expected unknown package to throw UnresolvedPackageException');
  }

  @test async 'BadPackageID- garbage name'() {
    let threw = false;
    try {
      await this.extensionManager.findPackage('LLLLl', '$DDFOIDFJIODFJ');
    } catch (e) {
      if (e instanceof InvalidPackageIdentityException) {
        threw = true;
      }
    }
    assert.equal(threw, true, 'Expected bad package id to throw InvalidPackageIdentityException');
  }

  @test async 'View Versions'() {
    // gets a package
    const pkg = await this.extensionManager.findPackage('echo-cli');
    // finds out if there are more versions
    assert.equal((await pkg.allVersions).length > 5, true);
  }


  @test async 'Install Extension'() {
    const dni = await this.extensionManager.findPackage('echo-cli', '1.0.8');
    const installing = this.extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
      installing.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); });
    });

    const extension = await installing;

    assert.notEqual(await extension.configuration, '');

    let done = false;

    for (const each of await this.extensionManager.getInstalledExtensions()) {
      done = true;
      // make sure we have one extension installed and that it is echo-cli (for testing)
      assert.equal(each.name, 'echo-cli');
    }

    assert.equal(done, true, 'Package is not installed');
  }

  @test async 'Install Extension via star'() {
    const dni = await this.extensionManager.findPackage('echo-cli', '*');
    const installing = this.extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
      installing.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); });
    });
    const extension = await installing;

    assert.notEqual(await extension.configuration, '');

    let done = false;

    for (const each of await this.extensionManager.getInstalledExtensions()) {
      done = true;
      // make sure we have one extension installed and that it is echo-cli (for testing)
      assert.equal(each.name, 'echo-cli');
    }

    assert.equal(done, true, 'Package is not installed');
  }

  @test async 'Force install'() {
    const dni = await this.extensionManager.findPackage('echo-cli', '*');
    const installing = this.extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
      installing.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); });
    });
    const extension = await installing;
    assert.notEqual(await extension.configuration, '');

    // erase the readme.md file in the installed folder (check if force works to reinstall)
    await asyncio.rmFile(await extension.configurationPath);

    // reinstall with force!
    const installing2 = this.extensionManager.installPackage(dni, true, 5 * 60 * 1000, (installing) => {
      installing.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); });
    });
    const extension2 = await installing2;

    // is the file back?
    assert.notEqual(await extension2.configuration, '');
  }


  @test async 'Test Start'() {
    try {
      const dni = await this.extensionManager.findPackage('none', 'fearthecowboy/echo-cli');
      const installing = this.extensionManager.installPackage(dni, false, 5 * 60 * 1000, (installing) => {
        installing.Message.Subscribe((s, m) => { console.log(`Installer:${m}`); });
      });
      const extension = await installing;
      assert.notEqual(await extension.configuration, '');
      const proc = await extension.start();
      await tasks.When(proc, 'exit');
    } catch (E) {
      // oh well...
      console.error(E);
      assert(false, 'FAILED DURING START TEST.');
    }
  }
}
