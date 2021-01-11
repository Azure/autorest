import supertest from "supertest";
import { MockApiServer } from "../../src/server";

export const testClient = (server: MockApiServer): supertest.SuperTest<supertest.Test> => {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  return supertest((server as any).app);
};
