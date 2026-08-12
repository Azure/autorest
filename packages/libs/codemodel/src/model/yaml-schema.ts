import { Schema, defineMappingTag, YAML11_SCHEMA as DEFAULT_SCHEMA } from "js-yaml";
import { ApiVersion } from "./common/api-version";
import { Aspect } from "./common/aspect";
import { CodeModel } from "./common/code-model";
import { ExternalDocumentation } from "./common/external-documentation";
import { Contact, Info, License } from "./common/info";
import { Languages } from "./common/languages";
import { Metadata, CSharpLanguage, Language } from "./common/metadata";
import { Operation, Request, OperationGroup } from "./common/operation";
import { Parameter, VirtualParameter } from "./common/parameter";
import { Property } from "./common/property";
import { Protocols } from "./common/protocols";
import { Response, SchemaResponse, BinaryResponse } from "./common/response";
import { Schemas } from "./common/schemas";
import { AnySchema, AnyObjectSchema } from "./common/schemas/any";
import { ArraySchema, ByteArraySchema } from "./common/schemas/array";
import { BinarySchema } from "./common/schemas/binary";
import { ChoiceSchema, ChoiceValue, SealedChoiceSchema } from "./common/schemas/choice";
import { ConditionalValue, ConditionalSchema, SealedConditionalSchema } from "./common/schemas/conditional";
import { ConstantValue, ConstantSchema } from "./common/schemas/constant";
import { DictionarySchema } from "./common/schemas/dictionary";
import { FlagSchema, FlagValue } from "./common/schemas/flag";
import { NumberSchema } from "./common/schemas/number";
import { GroupSchema, ObjectSchema, Discriminator, Relations, GroupProperty } from "./common/schemas/object";
import { BooleanSchema, CharSchema } from "./common/schemas/primitive";
import { OrSchema, XorSchema } from "./common/schemas/relationship";
import {
  StringSchema,
  ODataQuerySchema,
  CredentialSchema,
  UriSchema,
  UuidSchema,
  ArmIdSchema,
} from "./common/schemas/string";
import { DurationSchema, DateTimeSchema, DateSchema, UnixTimeSchema, TimeSchema } from "./common/schemas/time";
import { OAuth2SecurityScheme, KeySecurityScheme, Security } from "./common/security";
import { Value } from "./common/value";
import { AADTokenSecurityScheme, AzureKeySecurityScheme } from "./deprecated";
import {
  HttpWithBodyRequest,
  HttpParameter,
  HttpBinaryRequest,
  HttpMultipartRequest,
  HttpBinaryResponse,
  HttpRequest,
  HttpResponse,
  HttpModel,
  HttpHeader,
} from "./http/http";

function TypeInfo<U extends new (...args: any) => any>(type: U) {
  return TaggedTypeInfo(`!${type.name}`, type);
}

function TaggedTypeInfo<U extends new (...args: any) => any>(tagName: string, type: U) {
  return defineMappingTag(
    tagName,
    <any>{
      create: () => ({}),
      addPair: (carrier: any, key: any, value: any) => {
        carrier[key] = value;
        return carrier;
      },
      has: (carrier: any, key: any) => Object.prototype.hasOwnProperty.call(carrier, key),
      keys: (result: any) => Object.keys(result),
      get: (result: any, key: any) => result[key],
      finalize: (carrier: any) => Object.setPrototypeOf(carrier, type.prototype),
      identify: (value: any) => value instanceof type,
      represent: (value: any) => value,
    },
  );
}

export const codeModelSchema = DEFAULT_SCHEMA.withTags([
  TypeInfo(Security),

  TypeInfo(HttpModel),
  TypeInfo(HttpParameter),

  TypeInfo(HttpBinaryRequest),
  TypeInfo(HttpMultipartRequest),
  TypeInfo(HttpWithBodyRequest),
  TypeInfo(HttpRequest),

  TypeInfo(HttpBinaryResponse),
  TypeInfo(SchemaResponse),
  TypeInfo(HttpResponse),

  TypeInfo(HttpHeader),

  TypeInfo(BinaryResponse),
  TypeInfo(Response),

  TypeInfo(VirtualParameter),
  TypeInfo(Parameter),
  TypeInfo(GroupProperty),
  TypeInfo(Property),
  TypeInfo(Value),
  TypeInfo(Operation),
  TypeInfo(GroupSchema),
  TypeInfo(FlagSchema),
  TypeInfo(FlagValue),
  TypeInfo(NumberSchema),
  TypeInfo(StringSchema),
  TypeInfo(ArraySchema),
  TypeInfo(ObjectSchema),
  TypeInfo(ChoiceValue),
  TypeInfo(ConditionalValue),
  TypeInfo(ConstantValue),

  TaggedTypeInfo("!ChoiceSchema", ChoiceSchema),
  TaggedTypeInfo("!SealedChoiceSchema", SealedChoiceSchema),
  TaggedTypeInfo("!ConditionalSchema", ConditionalSchema),
  TaggedTypeInfo("!SealedConditionalSchema", SealedConditionalSchema),
  TypeInfo(ConstantSchema),
  TypeInfo(BooleanSchema),
  TypeInfo(ODataQuerySchema),
  TypeInfo(CredentialSchema),
  TypeInfo(UriSchema),
  TypeInfo(ArmIdSchema),
  TypeInfo(UuidSchema),
  TypeInfo(DurationSchema),
  TypeInfo(DateTimeSchema),
  TypeInfo(DateSchema),
  TypeInfo(TimeSchema),
  TypeInfo(CharSchema),
  TypeInfo(AnySchema),
  TypeInfo(AnyObjectSchema),
  TypeInfo(ByteArraySchema),
  TypeInfo(UnixTimeSchema),
  TypeInfo(DictionarySchema),
  TypeInfo(OrSchema),
  TypeInfo(XorSchema),
  TypeInfo(BinarySchema),
  TypeInfo(Schema),
  TypeInfo(Aspect),
  TypeInfo(CodeModel),
  TypeInfo(Request),
  TypeInfo(Schemas),
  TypeInfo(Discriminator),
  TypeInfo(Relations),

  TypeInfo(ExternalDocumentation),
  TypeInfo(Contact),
  TypeInfo(Info),
  TypeInfo(License),
  TypeInfo(OperationGroup),

  TypeInfo(OAuth2SecurityScheme),
  TypeInfo(KeySecurityScheme),

  TypeInfo(Languages),
  TypeInfo(Language),
  TypeInfo(CSharpLanguage),
  TypeInfo(Protocols),
  TypeInfo(ApiVersion),
  TypeInfo(Metadata),

  // Deprecated types for backward compatiblity only.
  TypeInfo(AADTokenSecurityScheme),
  TypeInfo(AzureKeySecurityScheme),
]);
