import { testClient } from "../../test/utils";
import { BODY_NOT_EQUAL_ERROR_MESSAGE } from "./request-validation";
import { MockApiServer } from "./server";

describe("Server Validation", () => {
  let server: MockApiServer;

  beforeEach(() => {
    server = new MockApiServer({
      port: 1234,
    });
  });

  it("returns response nothing to validate", async () => {
    server.add({
      request: {
        method: "get",
        url: "/no-validation",
      },
      response: {
        status: 200,
      },
    });

    const response = await testClient(server).get("/no-validation");
    expect(response.status).toEqual(200);
  });

  describe("when raw body match is requested", () => {
    beforeEach(() => {
      server.add({
        request: {
          method: "post",
          url: "/body-match-validation",
          body: {
            matchType: "exact",
            rawContent: `foo`,
          },
        },
        response: {
          status: 200,
        },
      });
    });

    it("response with BadRequest if no body is passed", async () => {
      const response = await testClient(server).post("/body-match-validation");
      expect(response.status).toEqual(400);
      expect(response.body).toEqual({
        message: BODY_NOT_EQUAL_ERROR_MESSAGE,
        expected: "foo",
        actual: undefined,
      });
    });

    it("response with BadRequest if no body doesn't match", async () => {
      const response = await testClient(server).post("/body-match-validation").send("bar");

      expect(response.status).toEqual(400);
      expect(response.body).toEqual({
        message: BODY_NOT_EQUAL_ERROR_MESSAGE,
        expected: "foo",
        actual: "bar",
      });
    });

    it("response with Success if body match", async () => {
      const response = await testClient(server).post("/body-match-validation").send("foo");

      expect(response.status).toEqual(200);
    });
  });
});
