/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/

// polyfills for language support 
require("../lib/polyfill.min.js");

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
    for await (const file of uri.EnumerateFiles(uri.CreateFolderUri(__dirname))) {
      if (file === uri.CreateFileUri(__filename)) {
        foundMyself = true;
      }
    }
    assert.strictEqual(foundMyself, true);
  }

  @test async "EnumerateFiles remote"() {
    let foundSomething = false;
    for await (const file of uri.EnumerateFiles("https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/", ["README.md"])) {
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

  @test @skip async "ResolveUri"() {
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
  }
}
