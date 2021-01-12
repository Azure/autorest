import { Request } from "express";

/**
 * Extension of the express.js request which include a rawBody.
 */
export interface RequestExt extends Request {
  rawBody?: string;
}
