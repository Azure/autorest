/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { CreateFileUri } from '../lib/ref/uri';
import { suite, test, slow, timeout, skip, only } from "mocha-typescript";
import * as assert from "assert";

import * as uri from "../lib/ref/uri";

@suite class Uri {
  @test @skip async "CreateFileUri"() {
    assert.strictEqual(uri.CreateFileUri("C:\\windows\\path\\file.txt"), "file:///C:/windows/path/file.txt");
    assert.strictEqual(uri.CreateFileUri("/linux/path/file.txt"), "file:///linux/path/file.txt");
    assert.throws(() => uri.CreateFileUri("relpath\\file.txt"));
    assert.throws(() => uri.CreateFileUri("relpath/file.txt"));
  }

  @test @skip async "CreateFolderUri"() {
    assert.strictEqual(uri.CreateFolderUri("C:\\windows\\path\\"), "file:///C:/windows/path/");
    assert.strictEqual(uri.CreateFolderUri("/linux/path/"), "file:///linux/path/");
    assert.throws(() => uri.CreateFolderUri("relpath\\"));
    assert.throws(() => uri.CreateFolderUri("relpath/"));
    assert.throws(() => uri.CreateFolderUri("relpath"));
    assert.throws(() => uri.CreateFolderUri("relpath"));
  }

  @test async "EnumerateFiles local"() {
    let foundMyself = false;
    for (const file of await uri.EnumerateFiles(uri.CreateFolderUri(__dirname))) {
      if (file === uri.CreateFileUri(__filename)) {
        foundMyself = true;
      }
    }
    assert.strictEqual(foundMyself, true);
  }

  @test async "EnumerateFiles remote"() {
    let foundSomething = false;
    for (const file of await uri.EnumerateFiles("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/", ["README.md"])) {
      foundSomething = true;
    }
    assert.strictEqual(foundSomething, true);
  }

  @test async "ExistsUri"() {
    assert.strictEqual(await uri.ExistsUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/README.md"), true);
    assert.strictEqual(await uri.ExistsUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/READMEx.md"), false);
    assert.strictEqual(await uri.ExistsUri(uri.CreateFileUri(__filename)), true);
    assert.strictEqual(await uri.ExistsUri(uri.CreateFileUri(__filename + "_")), false);
  }

  @test async "ParentFolderUri"() {
    assert.strictEqual(
      uri.ParentFolderUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/README.md"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/");
    assert.strictEqual(
      uri.ParentFolderUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/");
    assert.strictEqual(
      uri.ParentFolderUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/"),
      "https://raw.githubusercontent.com/Azure/");
    assert.strictEqual(
      uri.ParentFolderUri("https://raw.githubusercontent.com/Azure/"),
      "https://raw.githubusercontent.com/");
    assert.strictEqual(
      uri.ParentFolderUri("https://raw.githubusercontent.com/"),
      "https://");
    assert.strictEqual(
      uri.ParentFolderUri("https://"),
      null);
  }

  @test async "ReadUri"() {
    assert.ok((await uri.ReadUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/README.md")).length > 0);
    assert.ok((await uri.ReadUri(CreateFileUri(__filename))).length > 0);
  }

  @test async "ResolveUri"() {
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/", "README.md"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/README.md");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/", "../README.md"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/README.md");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master", "README.md"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/README.md");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master", "file:///README.md"),
      "file:///README.md");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master", "/README.md"),
      "file:///README.md");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master", "C:\\README.md"),
      "file:///C:/README.md");
    // multi-slash collapsing
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/", "folder///file.md"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/folder/file.md");
    // token forwarding
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/file1.json?token=asd%3Dnot_really_a_token123%3D", "./file2.json"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/file2.json?token=asd%3Dnot_really_a_token123%3D");
    assert.strictEqual(
      uri.ResolveUri("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/file1.json?token=asd%3Dnot_really_a_token123%3D", "https://evil.com/file2.json"),
      "https://evil.com/file2.json");
    assert.strictEqual(
      uri.ResolveUri("https://somewhere.com/file1.json?token=asd%3Dnot_really_a_token123%3D", "./file2.json"),
      "https://somewhere.com/file2.json");
  }

  @test async "ToRawDataUrl"() {
    // GitHub blob
    assert.strictEqual(
      uri.ToRawDataUrl("https://github.com/Microsoft/vscode/blob/master/.gitignore"),
      "https://raw.githubusercontent.com/Microsoft/vscode/master/.gitignore");
    assert.strictEqual(
      uri.ToRawDataUrl("https://github.com/Microsoft/TypeScript/blob/master/README.md"),
      "https://raw.githubusercontent.com/Microsoft/TypeScript/master/README.md");
    assert.strictEqual(
      uri.ToRawDataUrl("https://github.com/Microsoft/TypeScript/blob/master/tests/cases/compiler/APISample_watcher.ts"),
      "https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts");
    assert.strictEqual(
      uri.ToRawDataUrl("https://github.com/Azure/azure-rest-api-specs/blob/master/arm-web/2015-08-01/AppServiceCertificateOrders.json"),
      "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-web/2015-08-01/AppServiceCertificateOrders.json");

    // unknown / already raw
    assert.strictEqual(
      uri.ToRawDataUrl("https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts"),
      "https://raw.githubusercontent.com/Microsoft/TypeScript/master/tests/cases/compiler/APISample_watcher.ts");
    assert.strictEqual(
      uri.ToRawDataUrl("https://assets.onestore.ms/cdnfiles/external/uhf/long/9a49a7e9d8e881327e81b9eb43dabc01de70a9bb/images/microsoft-gray.png"),
      "https://assets.onestore.ms/cdnfiles/external/uhf/long/9a49a7e9d8e881327e81b9eb43dabc01de70a9bb/images/microsoft-gray.png");
    assert.strictEqual(
      uri.ToRawDataUrl("README.md"),
      "README.md");
    assert.strictEqual(
      uri.ToRawDataUrl("compiler/APISample_watcher.ts"),
      "compiler/APISample_watcher.ts");
    assert.strictEqual(
      uri.ToRawDataUrl("compiler\\APISample_watcher.ts"),
      "compiler\\APISample_watcher.ts");
    assert.strictEqual(
      uri.ToRawDataUrl("C:\\arm-web\\2015-08-01\\AppServiceCertificateOrders.json"),
      "C:\\arm-web\\2015-08-01\\AppServiceCertificateOrders.json");
  }
}
