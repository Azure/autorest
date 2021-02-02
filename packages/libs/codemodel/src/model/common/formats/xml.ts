import { SerializationFormat } from "../schema";

export interface XmlSerlializationFormat extends SerializationFormat {
  name?: string;
  namespace?: string; // url
  prefix?: string;
  attribute: boolean;
  wrapped: boolean;
  text: boolean;
}
