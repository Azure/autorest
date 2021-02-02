import assert from "assert";
import * as aio from "@azure-tools/async-io";
import * as datastore from "@azure-tools/datastore";

/* eslint-disable @typescript-eslint/no-empty-function */

require("source-map-support").install();

import { Oai2ToOai3 } from "../src/converter";
import { OpenAPI2Document } from "../src/oai2";

describe("OpenAPI2 -> OpenAPI3 Conversion", () => {
  it("test conversion - simple", async () => {
    const swaggerUri = "mem://swagger.yaml";
    const oai3Uri = "mem://oai3.yaml";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/swagger.yaml`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/openapi.yaml`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      // const swaggerAsText = FastStringify(convert.generated);
      // console.log(swaggerAsText);

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("test conversion - tiny", async () => {
    const swaggerUri = "mem://tiny-swagger.yaml";
    const oai3Uri = "mem://tiny-oai3.yaml";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/tiny-swagger.yaml`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/tiny-openapi.yaml`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      // const swaggerAsText = FastStringify(convert.generated);
      // console.log(swaggerAsText);

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("test conversion - ApiManagementClient", async () => {
    const swaggerUri = "mem://ApiManagementClient-swagger.json";
    const oai3Uri = "mem://ApiManagementClient-oai3.json";

    const swagger = await aio.readFile(
      `${__dirname}/../../test/resources/conversion/oai2/ApiManagementClient-swagger.json`,
    );
    const oai3 = await aio.readFile(
      `${__dirname}/../../test/resources/conversion/oai3/ApiManagementClient-openapi.json`,
    );

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      // const swaggerAsText = FastStringify(convert.generated);
      // console.log(swaggerAsText);

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("request body - copying extensions", async () => {
    const swaggerUri = "mem://request-body-swagger.yaml";
    const oai3Uri = "mem://request-body-openapi.yaml";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/request-body-swagger.yaml`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/request-body-openapi.yaml`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      // const swaggerAsText = FastStringify(convert.generated);
      // console.log(swaggerAsText);

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("headers", async () => {
    const swaggerUri = "mem://header2.json";
    const oai3Uri = "mem://header3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/header.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/header.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("additionalProperties", async () => {
    const swaggerUri = "mem://additionalProperties2.json";
    const oai3Uri = "mem://additionalProperties3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/additionalProperties.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/additionalProperties.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("xml-service", async () => {
    const swaggerUri = "mem://xml-service2.json";
    const oai3Uri = "mem://xml-service3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/xml-service.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/xml-service.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("xms-error-responses", async () => {
    const swaggerUri = "mem://xms-error-responses2.json";
    const oai3Uri = "mem://xms-error-responses3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/xms-error-responses.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/xms-error-responses.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("validation", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/validation.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/validation.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("storage", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/storage.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/storage.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("url", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/url.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/url.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("url-multi-collectionFormat", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(
      `${__dirname}/../../test/resources/conversion/oai2/url-multi-collectionFormat.json`,
    );
    const oai3 = await aio.readFile(
      `${__dirname}/../../test/resources/conversion/oai3/url-multi-collectionFormat.json`,
    );

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("complex-model", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/complex-model.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/complex-model.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("extensible-enums-swagger", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(
      `${__dirname}/../../test/resources/conversion/oai2/extensible-enums-swagger.json`,
    );
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/extensible-enums-swagger.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("lro", async () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/lro.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/lro.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("exec-service", () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/exec-service.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/exec-service.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });

  it("LUIS runtime", () => {
    const swaggerUri = "mem://oai2.json";
    const oai3Uri = "mem://oai3.json";

    const swagger = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai2/luis.json`);
    const oai3 = await aio.readFile(`${__dirname}/../../test/resources/conversion/oai3/luis.json`);

    const map = new Map<string, string>([
      [swaggerUri, swagger],
      [oai3Uri, oai3],
    ]);
    const mfs = new datastore.MemoryFileSystem(map);

    const cts: datastore.CancellationTokenSource = {
      cancel() {},
      dispose() {},
      token: { isCancellationRequested: false, onCancellationRequested: <any>null },
    };
    const ds = new datastore.DataStore(cts.token);
    const scope = ds.GetReadThroughScope(mfs);
    const swaggerDataHandle = await scope.Read(swaggerUri);
    const originalDataHandle = await scope.Read(oai3Uri);

    assert(swaggerDataHandle != null);
    assert(originalDataHandle != null);

    if (swaggerDataHandle && originalDataHandle) {
      const swag = await swaggerDataHandle.ReadObject<OpenAPI2Document>();
      const original = await originalDataHandle.ReadObject();
      const convert = new Oai2ToOai3(swaggerUri, swag);

      // run the conversion
      await convert.convert();

      assert.deepStrictEqual(convert.generated, original, "Should be the same");
    }
  });
});
