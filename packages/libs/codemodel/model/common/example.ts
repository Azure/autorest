import { uri } from "./uri";

/** example data [UNFINISHED] */
export interface Example {
  summary?: string;
  description?: string;
  value?: any;
  externalValue?: uri; // uriref
}
