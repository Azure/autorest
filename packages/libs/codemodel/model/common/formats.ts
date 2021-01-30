import { XmlSerlializationFormat } from "./formats/xml";
import { SerializationFormat } from "./schema";

/** custom extensible metadata for individual serialization formats */
export interface SerializationFormats {
  json?: SerializationFormat;
  xml?: XmlSerlializationFormat;
  protobuf?: SerializationFormat;
  binary?: SerializationFormat;
}
