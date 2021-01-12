import { testClient } from "../../test/utils";
import { MockApiServer } from "./server";

const server = new MockApiServer({
  port: 1234,
});

describe("Server Templating", () => {
  it("interpolate headers", async () => {
    server.add({
      request: {
        method: "get",
        url: "/header-templating",
      },
      response: {
        status: 200,
        headers: {
          myheader: "{{request.headers.myheader}}",
        },
      },
    });

    const headerValue = "my-header-value-1";
    const response = await testClient(server).get("/header-templating").set("myheader", headerValue);
    expect(response.headers["myheader"]).toEqual(headerValue);
  });

  it("interpolate body", async () => {
    server.add({
      request: {
        method: "get",
        url: "/body-templating",
      },
      response: {
        status: 200,
        body: {
          content: `foo bar {{request.headers.myheader}}`,
        },
      },
    });

    const headerValue = "my-header-value-1";
    const response = await testClient(server).get("/body-templating").set("myheader", headerValue);
    expect(response.text).toEqual(`foo bar ${headerValue}`);
  });
});
