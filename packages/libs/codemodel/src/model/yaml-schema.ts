import { Schema, Type, DEFAULT_SCHEMA } from "js-yaml";
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
import { StringSchema, ODataQuerySchema, CredentialSchema, UriSchema, UuidSchema } from "./common/schemas/string";
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
  return new Type(`!${type.name}`, {
    kind: "mapping",
    instanceOf: type,
    construct: (i) => Object.setPrototypeOf(i, type.prototype),
  });
}

export const codeModelSchema = DEFAULT_SCHEMA.extend([
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

  new Type("!ChoiceSchema", {
    kind: "mapping",
    instanceOf: ChoiceSchema,
    construct: (i) => Object.setPrototypeOf(i, ChoiceSchema.prototype),
  }),
  new Type("!SealedChoiceSchema", {
    kind: "mapping",
    instanceOf: SealedChoiceSchema,
    construct: (i) => Object.setPrototypeOf(i, SealedChoiceSchema.prototype),
  }),
  new Type("!ConditionalSchema", {
    kind: "mapping",
    instanceOf: ConditionalSchema,
    construct: (i) => Object.setPrototypeOf(i, ConditionalSchema.prototype),
  }),
  new Type("!SealedConditionalSchema", {
    kind: "mapping",
    instanceOf: SealedConditionalSchema,
    construct: (i) => Object.setPrototypeOf(i, SealedConditionalSchema.prototype),
  }),
  TypeInfo(ConstantSchema),
  TypeInfo(BooleanSchema),
  TypeInfo(ODataQuerySchema),
  TypeInfo(CredentialSchema),
  TypeInfo(UriSchema),
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
