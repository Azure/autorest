import {
  Model as oai3,
  Dereferenced,
  dereference,
  Refable,
  JsonType,
  IntegerFormat,
  StringFormat,
  NumberFormat,
  MediaType,
  filterOutXDash,
} from "@azure-tools/openapi";
import * as OpenAPI from "@azure-tools/openapi";
import { items, values, Dictionary, length, keys } from "@azure-tools/linq";
import {
  HttpMethod,
  HttpModel,
  CodeModel,
  Operation,
  SetType,
  HttpRequest,
  BooleanSchema,
  Schema,
  NumberSchema,
  ArraySchema,
  Parameter,
  ChoiceSchema,
  StringSchema,
  ObjectSchema,
  ByteArraySchema,
  CharSchema,
  DateSchema,
  DateTimeSchema,
  DurationSchema,
  UuidSchema,
  UriSchema,
  CredentialSchema,
  ODataQuerySchema,
  UnixTimeSchema,
  SchemaType,
  SchemaContext,
  OrSchema,
  XorSchema,
  DictionarySchema,
  ParameterLocation,
  SerializationStyle,
  ImplementationLocation,
  Property,
  ComplexSchema,
  HttpWithBodyRequest,
  HttpBinaryRequest,
  HttpParameter,
  Response,
  HttpResponse,
  HttpBinaryResponse,
  SchemaResponse,
  SchemaUsage,
  SealedChoiceSchema,
  ExternalDocumentation,
  BinaryResponse,
  BinarySchema,
  Discriminator,
  Relations,
  AnySchema,
  ConstantSchema,
  ConstantValue,
  HttpHeader,
  ChoiceValue,
  Request,
  OperationGroup,
  TimeSchema,
  HttpMultipartRequest,
  AnyObjectSchema,
} from "@autorest/codemodel";
import { Session, Channel } from "@autorest/extension-base";
import { Interpretations, XMSEnum } from "./interpretations";
import { fail, minimum, pascalCase, KnownMediaType } from "@azure-tools/codegen";
import { ModelerFourOptions } from "./modelerfour-options";
import { isContentTypeParameterDefined } from "./utils";
import { BodyProcessor } from "./body-processor";
import { isSchemaBinary } from "./schema-utils";
import { SecurityProcessor } from "./security-processor";

/** adds only if the item is not in the collection already
 *
 * @note  While this isn't very efficient, it doesn't disturb the original
 * collection, so you won't get inadvertent side effects from using Set, etc.
 */
function pushDistinct<T>(targetArray: Array<T>, ...items: Array<T>): Array<T> {
  for (const i of items) {
    if (!targetArray.includes(i)) {
      targetArray.push(i);
    }
  }
  return targetArray;
}

/** asserts that the value is not null or undefined  */
function is(value: any): asserts value is object | string | number | boolean {
  if (value === undefined || value === null) {
    throw new Error(`Intenral assertion failure -- value must not be null`);
  }
}

/** Acts as a cache for processing inputs.
 *
 * If the input is undefined, the ouptut is always undefined.
 * for a given input, the process is only ever called once.
 *
 *
 */
class ProcessingCache<In, Out> {
  private results = new Map<In, Out>();
  constructor(private transform: (orig: In, ...args: Array<any>) => Out) {}
  has(original: In | undefined) {
    return !!original && !!this.results.get(original);
  }
  set(original: In, result: Out) {
    this.results.set(original, result);
    return result;
  }
  process(original: In | undefined, ...args: Array<any>): Out | undefined {
    if (original) {
      const result: Out = this.results.get(original) || this.transform(original, ...args);
      this.results.set(original, result);
      return result;
    }
    return undefined;
  }
}

interface InputOperation {
  operation: OpenAPI.HttpOperation;
  method: string;
  path: string;
  pathItem: OpenAPI.PathItem;
}

export class ModelerFour {
  codeModel: CodeModel;
  private input: oai3;
  private inputOperations = new Array<InputOperation>();
  protected interpret: Interpretations;

  private apiVersionMode!: "auto" | "client" | "method" | "profile" | "none";
  private apiVersionParameter!: "choice" | "constant" | undefined;
  private useModelNamespace!: boolean | undefined;
  private profileFilter!: Array<string>;
  private apiVersionFilter!: Array<string>;
  private schemaCache = new ProcessingCache((schema: OpenAPI.Schema, name: string) =>
    this.processSchemaImpl(schema, name),
  );
  private options: ModelerFourOptions = {};
  private uniqueNames: Dictionary<any> = {};
  private bodyProcessor: BodyProcessor;
  private securityProcessor: SecurityProcessor;

  constructor(protected session: Session<oai3>) {
    this.input = session.model; // shadow(session.model, filename);

    const i = this.input.info;

    this.codeModel = new CodeModel(i.title || "MISSING·TITLE", false, {
      info: {
        description: i.description,
        contact: i.contact,
        license: i.license,
        termsOfService: i.termsOfService,
        externalDocs: filterOutXDash<ExternalDocumentation>(this.input.externalDocs as any),
        extensions: Interpretations.getExtensionProperties(i),
      },
      extensions: Interpretations.getExtensionProperties(this.input),
      protocol: {
        http: new HttpModel(),
      },
    });
    this.interpret = new Interpretations(session);
    this.bodyProcessor = new BodyProcessor(session);
    this.securityProcessor = new SecurityProcessor(session, this.interpret);

    this.preprocessOperations();
  }

  preprocessOperations() {
    // preprocess to get all http operations flattend out into a nice neat collection
    for (const { key: path, value: pathItem } of this.resolveDictionary(this.input.paths)) {
      for (const httpMethod of [
        HttpMethod.Delete,
        HttpMethod.Get,
        HttpMethod.Head,
        HttpMethod.Options,
        HttpMethod.Patch,
        HttpMethod.Post,
        HttpMethod.Put,
        HttpMethod.Trace,
      ]) {
        const httpOperation = pathItem[httpMethod];
        if (httpOperation) {
          this.inputOperations.push({
            method: httpMethod,
            path: this.interpret.getPath(pathItem, httpOperation, path),
            pathItem,
            operation: httpOperation,
          });
        }
      }
    }
  }

  initApiVersionMode(apiVersionParameter: "choice" | "constant" | undefined, useModelNamespace: boolean | undefined) {
    if (this.profileFilter.length > 0) {
      // must be profile mode.
      return "profile";
    }

    // see how many api versions there are for all the operations
    const allApiVersions = values(this.inputOperations)
      .selectMany((each) => <Array<string>>this.interpret.xmsMetaFallback(each.operation, each.pathItem, "apiVersions"))
      .distinct()
      .toArray();
    switch (allApiVersions.length) {
      case 0:
        this.useModelNamespace = false;
        return "none";

      case 1:
        this.apiVersionParameter = apiVersionParameter || "constant";
        this.useModelNamespace = useModelNamespace || false;
        return "client";
    }

    // multiple api versions in play.
    const multiVersionPerOperation = values(this.inputOperations)
      .select((each) =>
        length(<Array<string>>this.interpret.xmsMetaFallback(each.operation, each.pathItem, "apiVersions")),
      )
      .any((each) => each > 1);
    if (!multiVersionPerOperation) {
      // operations have one single api version each
      this.apiVersionParameter = apiVersionParameter || "constant";
      this.useModelNamespace = useModelNamespace || false;
      return "method";
    }

    // methods can have more than one api version
    this.apiVersionParameter = apiVersionParameter || "choice";
    this.useModelNamespace = useModelNamespace || true;
    return "method";
  }

  async init() {
    await this.securityProcessor.init();

    this.options = await this.session.getValue("modelerfour", {});

    if (this.options["treat-type-object-as-anything"]) {
      this.session.warning(
        "modelerfour.treat-type-object-as-anything options is a temporary flag. It WILL be removed in the future.",
        ["UsingTemporaryFlag"],
      );
    }
    // grab override-client-name
    const newTitle = await this.session.getValue("override-client-name", "");
    if (newTitle) {
      this.codeModel.info.title = newTitle;
    }

    this.profileFilter = await this.session.getValue("profile", []);
    this.apiVersionFilter = await this.session.getValue("api-version", []);

    const apiVersionMode = await this.session.getValue("api-version-mode", "auto");

    const apiVersionParameter =
      (await this.session.getValue<"choice" | "constant" | null>("api-version-parameter", null)) ?? undefined;
    const useModelNamespace = (await this.session.getValue<boolean | null>("use-model-namespace", null)) ?? undefined;

    if (apiVersionMode === "auto") {
      // detect the apiversion mode
      this.apiVersionMode = this.initApiVersionMode(apiVersionParameter, useModelNamespace);
    } else {
      this.apiVersionMode = apiVersionMode as any;
      // just set the other parameters
      this.initApiVersionMode(apiVersionParameter, useModelNamespace);
    }

    this.session.message({ Channel: Channel.Verbose, Text: `  ModelerFour/api-version-mode:${this.apiVersionMode}` });
    this.session.message({
      Channel: Channel.Verbose,
      Text: `  ModelerFour/api-version-parameter:${this.apiVersionParameter}`,
    });
    this.session.message({
      Channel: Channel.Verbose,
      Text: `  ModelerFour/use-model-namespace:${this.useModelNamespace}`,
    });

    return this;
  }

  private resolve<T>(item: Refable<T>): Dereferenced<T> {
    return dereference(this.input, item);
  }

  private use<T, Q = void>(item: Refable<T> | undefined, action: (name: string, instance: T) => Q): Q {
    const i = dereference(this.input, item);
    if (i.instance) {
      return action(i.name, i.instance);
    }
    throw new Error(`Unresolved item '${item}'`);
  }

  resolveArray<T>(source: Array<Refable<T>> | undefined) {
    return (source ?? []).map((each) => dereference(this.input, each).instance);
  }

  resolveDictionary<T>(source?: Dictionary<Refable<T>>) {
    return items(source)
      .linq.select((each) => ({
        key: each.key,
        value: dereference(this.input, each.value).instance,
      }))
      .where((each) => each.value !== undefined);
  }

  location(obj: any): string {
    const locations = obj["x-ms-metadata"]?.originalLocations;
    return locations ? `Location:\n   ${locations.join("\n   ")}` : "";
  }

  processBooleanSchema(name: string, schema: OpenAPI.Schema): BooleanSchema {
    return this.codeModel.schemas.add(
      new BooleanSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }
  processIntegerSchema(name: string, schema: OpenAPI.Schema): NumberSchema {
    return this.codeModel.schemas.add(
      new NumberSchema(
        this.interpret.getName(name, schema),
        this.interpret.getDescription("", schema),
        SchemaType.Integer,
        schema.format === IntegerFormat.Int64 ? 64 : 32,
        {
          extensions: this.interpret.getExtensionProperties(schema),
          summary: schema.title,
          defaultValue: schema.default,
          deprecated: this.interpret.getDeprecation(schema),
          apiVersions: this.interpret.getApiVersions(schema),
          example: this.interpret.getExample(schema),
          externalDocs: this.interpret.getExternalDocs(schema),
          serialization: this.interpret.getSerialization(schema),
          maximum: schema.maximum,
          minimum: schema.minimum,
          multipleOf: schema.multipleOf,
          exclusiveMaximum: schema.exclusiveMaximum,
          exclusiveMinimum: schema.exclusiveMinimum,
        },
      ),
    );
  }
  processNumberSchema(name: string, schema: OpenAPI.Schema): NumberSchema {
    return this.codeModel.schemas.add(
      new NumberSchema(
        this.interpret.getName(name, schema),
        this.interpret.getDescription("", schema),
        SchemaType.Number,
        schema.format === NumberFormat.Decimal ? 128 : schema.format == NumberFormat.Double ? 64 : 32,
        {
          extensions: this.interpret.getExtensionProperties(schema),
          summary: schema.title,
          defaultValue: schema.default,
          deprecated: this.interpret.getDeprecation(schema),
          apiVersions: this.interpret.getApiVersions(schema),
          example: this.interpret.getExample(schema),
          externalDocs: this.interpret.getExternalDocs(schema),
          serialization: this.interpret.getSerialization(schema),
          maximum: schema.maximum,
          minimum: schema.minimum,
          multipleOf: schema.multipleOf,
          exclusiveMaximum: schema.exclusiveMaximum,
          exclusiveMinimum: schema.exclusiveMinimum,
        },
      ),
    );
  }
  processStringSchema(name: string, schema: OpenAPI.Schema): StringSchema {
    return this.codeModel.schemas.add(
      new StringSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        maxLength: schema.maxLength ? Number(schema.maxLength) : undefined,
        minLength: schema.minLength ? Number(schema.minLength) : undefined,
        pattern: schema.pattern ? String(schema.pattern) : undefined,
      }),
    );
  }
  processCredentialSchema(name: string, schema: OpenAPI.Schema): CredentialSchema {
    return this.codeModel.schemas.add(
      new CredentialSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        maxLength: schema.maxLength ? Number(schema.maxLength) : undefined,
        minLength: schema.minLength ? Number(schema.minLength) : undefined,
        pattern: schema.pattern ? String(schema.pattern) : undefined,
      }),
    );
  }
  processUriSchema(name: string, schema: OpenAPI.Schema): UriSchema {
    return this.codeModel.schemas.add(
      new UriSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        maxLength: schema.maxLength ? Number(schema.maxLength) : undefined,
        minLength: schema.minLength ? Number(schema.minLength) : undefined,
        pattern: schema.pattern ? String(schema.pattern) : undefined,
      }),
    );
  }
  processUuidSchema(name: string, schema: OpenAPI.Schema): UuidSchema {
    return this.codeModel.schemas.add(
      new UuidSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }
  processDurationSchema(name: string, schema: OpenAPI.Schema): DurationSchema {
    return this.codeModel.schemas.add(
      new DurationSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }
  processDateTimeSchema(name: string, schema: OpenAPI.Schema): DateTimeSchema {
    return this.codeModel.schemas.add(
      new DateTimeSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        format: schema.format === StringFormat.DateTimeRfc1123 ? StringFormat.DateTimeRfc1123 : StringFormat.DateTime,
      }),
    );
  }

  processTimeSchema(name: string, schema: OpenAPI.Schema): TimeSchema {
    return this.codeModel.schemas.add(
      new TimeSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }

  processDateSchema(name: string, schema: OpenAPI.Schema): DateSchema {
    return this.codeModel.schemas.add(
      new DateSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }
  processCharacterSchema(name: string, schema: OpenAPI.Schema): CharSchema {
    return this.codeModel.schemas.add(
      new CharSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }
  processByteArraySchema(name: string, schema: OpenAPI.Schema): ByteArraySchema {
    return this.codeModel.schemas.add(
      new ByteArraySchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        format: schema.format === StringFormat.Base64Url ? StringFormat.Base64Url : StringFormat.Byte,
      }),
    );
  }
  processArraySchema(name: string, schema: OpenAPI.Schema): ArraySchema {
    const itemSchema = this.resolve(schema.items);
    if (itemSchema.instance === undefined) {
      this.session.error(
        `Array schema '${name}' is missing schema for items`,
        ["Modeler", "MissingArrayElementType"],
        schema,
      );
      throw Error();
    }
    const elementType = this.processSchema(itemSchema.name || "array:itemschema", itemSchema.instance);
    return this.codeModel.schemas.add(
      new ArraySchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), elementType, {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        nullableItems: (<any>schema.items).nullable || itemSchema.instance?.nullable,
        serialization: this.interpret.getSerialization(schema),
        maxItems: schema.maxItems ? Number(schema.maxItems) : undefined,
        minItems: schema.minItems ? Number(schema.minItems) : undefined,
        uniqueItems: schema.uniqueItems ? true : undefined,
      }),
    );
  }

  _stringSchema?: StringSchema;
  get stringSchema() {
    return (
      this._stringSchema ||
      (this._stringSchema = this.codeModel.schemas.add(new StringSchema("string", "simple string")))
    );
  }
  _charSchema?: CharSchema;
  get charSchema() {
    return this._charSchema || (this._charSchema = this.codeModel.schemas.add(new CharSchema("char", "simple char")));
  }

  _booleanSchema?: BooleanSchema;
  get booleanSchema() {
    return (
      this._booleanSchema ||
      (this._booleanSchema = this.codeModel.schemas.add(new BooleanSchema("bool", "simple boolean")))
    );
  }

  private _anySchema?: AnySchema;
  public get anySchema(): AnySchema {
    return this._anySchema ?? (this._anySchema = this.codeModel.schemas.add(new AnySchema("Anything")));
  }

  private _anyObjectSchema?: AnyObjectSchema;
  public get anyObjectSchema(): AnySchema {
    if (this.options["treat-type-object-as-anything"]) {
      return this.anySchema;
    }
    return (
      this._anyObjectSchema ?? (this._anyObjectSchema = this.codeModel.schemas.add(new AnyObjectSchema("Any object")))
    );
  }

  getSchemaForString(schema: OpenAPI.Schema): Schema {
    switch (schema.format) {
      // member should be byte array
      // on wire format should be base64url
      case StringFormat.Base64Url:
      case StringFormat.Byte:
      case StringFormat.Certificate:
        return this.processByteArraySchema("", schema);

      case StringFormat.Char:
        return this.charSchema;

      case StringFormat.Date:
        return this.processDateSchema("", schema);

      case StringFormat.Time:
        return this.processTimeSchema("", schema);

      case StringFormat.DateTime:
      case StringFormat.DateTimeRfc1123:
        return this.processDateTimeSchema("", schema);

      case StringFormat.Duration:
        return this.processDurationSchema("", schema);

      case StringFormat.Uuid:
        return this.processUuidSchema("", schema);

      case StringFormat.Url:
        return this.processUriSchema("", schema);

      case StringFormat.Password:
        return this.stringSchema;

      case StringFormat.OData:
        return this.processOdataSchema("", schema);

      default:
        return this.stringSchema;
    }
  }

  getPrimitiveSchemaForEnum(schema: OpenAPI.Schema) {
    switch (schema.type) {
      case JsonType.String:
        return this.getSchemaForString(schema);
      case JsonType.Boolean:
        return this.booleanSchema;
      case JsonType.Number:
        return this.processNumberSchema("number", schema);
      case JsonType.Integer:
        return this.processIntegerSchema("integer", schema);
      case undefined:
        if (length(schema.enum) > 0 && values(schema.enum).all((each) => typeof each === "string")) {
          this.session.warning(
            `The enum schema '${schema?.["x-ms-metadata"]?.name}' with an undefined type and enum values is ambiguous. This has been auto-corrected to 'type:string'`,
            ["Modeler", "MissingType"],
            schema,
          );
          schema.type = JsonType.String;
          return this.getSchemaForString(schema);
        }
    }
    throw Error(
      `Enum types of '${schema.type}' and format '${schema.format}' are not supported. Correct your input (${schema["x-ms-metadata"]?.name}).`,
    );
  }

  /**
   *
   * @param name Name of the schema
   * @param schema OpenApi3 schema.
   * @returns List of choicevalue from parents enum(refed using allOf) if any.
   */
  private getChoiceSchemaParentValues(name: string, schema: OpenAPI.Schema): ChoiceValue[] {
    if (!schema.allOf) {
      return [];
    }

    const parentChoices: ChoiceValue[] = [];
    const parents = schema.allOf?.map((x) => this.use(x, (n, i) => this.processSchema(n, i)));
    for (const parent of parents) {
      if (parent.type === SchemaType.Choice || parent.type === SchemaType.SealedChoice) {
        const parentChoice = parent as ChoiceSchema;
        parentChoices.push(...parentChoice.choices);
      } else {
        throw new Error(
          `Unexpected parent type for enum ${name}. ${parent.language.default.name} should be an enum of the same type but is a ${parent.type}`,
        );
      }
    }
    return parentChoices.map((x) => new ChoiceValue("", "", "", x));
  }

  processChoiceSchema(name: string, schema: OpenAPI.Schema): ChoiceSchema | SealedChoiceSchema | ConstantSchema {
    const xmse = <XMSEnum>schema["x-ms-enum"];
    name = (xmse && xmse.name) || this.interpret.getName(name, schema);

    const alwaysSeal = this.options[`always-seal-x-ms-enums`] === true;
    const sealed = xmse && (alwaysSeal || !xmse.modelAsString);

    const parentChoices = this.getChoiceSchemaParentValues(name, schema);
    const type = this.getPrimitiveSchemaForEnum(schema);
    const choices = [...parentChoices, ...this.interpret.getEnumChoices(schema)];

    // model as string forces it to be a choice/enum.
    if (!alwaysSeal && xmse?.modelAsString !== true && choices.length === 1) {
      const constVal = choices[0].value;

      return this.codeModel.schemas.add(
        new ConstantSchema(name, this.interpret.getDescription(``, schema), {
          extensions: this.interpret.getExtensionProperties(schema),
          summary: schema.title,
          defaultValue: schema.default,
          deprecated: this.interpret.getDeprecation(schema),
          apiVersions: this.interpret.getApiVersions(schema),
          example: this.interpret.getExample(schema),
          externalDocs: this.interpret.getExternalDocs(schema),
          serialization: this.interpret.getSerialization(schema),
          valueType: type,
          value: new ConstantValue(this.interpret.getConstantValue(schema, constVal)),
        }),
      );
    }

    if (!sealed) {
      return this.codeModel.schemas.add(
        new ChoiceSchema(name, this.interpret.getDescription("", schema), {
          extensions: this.interpret.getExtensionProperties(schema),
          summary: schema.title,
          defaultValue: schema.default,
          deprecated: this.interpret.getDeprecation(schema),
          apiVersions: this.interpret.getApiVersions(schema),
          example: this.interpret.getExample(schema),
          externalDocs: this.interpret.getExternalDocs(schema),
          serialization: this.interpret.getSerialization(schema),
          choiceType: type as any,
          choices,
        }),
      );
    }

    return this.codeModel.schemas.add(
      new SealedChoiceSchema(name, this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        choiceType: type as any,
        choices,
      }),
    );
  }
  processOrSchema(name: string, schema: OpenAPI.Schema): OrSchema {
    throw new Error("Method not implemented.");
  }
  processXorSchema(name: string, schema: OpenAPI.Schema): XorSchema {
    throw new Error("Method not implemented.");
  }
  processDictionarySchema(name: string, schema: OpenAPI.Schema): DictionarySchema {
    const dictSchema = new DictionarySchema<any>(
      this.interpret.getName(name, schema),
      this.interpret.getDescription("", schema),
      null,
    );
    // cache this now before we accidentally recurse on this type.
    this.schemaCache.set(schema, dictSchema);

    let elementSchema: Schema;
    let elementNullable: boolean | undefined;
    if (schema.additionalProperties === true) {
      elementSchema = this.anySchema;
    } else {
      const eschema = this.resolve(schema.additionalProperties);
      const ei = eschema.instance;
      if (ei && this.interpret.isEmptyObject(ei)) {
        elementSchema = this.anyObjectSchema;
      } else {
        elementNullable = (<any>schema.additionalProperties)["nullable"] || (ei && ei.nullable) || undefined;
        elementSchema = this.processSchema(eschema.name || "", <OpenAPI.Schema>eschema.instance);
      }
    }

    dictSchema.language.default.description = this.interpret.getDescription(
      `Dictionary of <${elementSchema.language.default.name}>`,
      schema,
    );
    dictSchema.elementType = elementSchema;
    dictSchema.nullableItems = elementNullable;

    return this.codeModel.schemas.add(dictSchema);
  }

  findPolymorphicDiscriminator(schema: OpenAPI.Schema | undefined): OpenAPI.Discriminator | undefined {
    if (schema) {
      if (schema.type === JsonType.Object) {
        if (schema.discriminator) {
          return schema.discriminator;
        }
        return this.resolveArray(schema.allOf)
          .map((each) => this.findPolymorphicDiscriminator(each))
          .filter((x) => !!x)[0];
      }
    }
    return undefined;
  }

  createObjectSchema(name: string, schema: OpenAPI.Schema) {
    const discriminatorProperty = schema?.discriminator?.propertyName ? schema.discriminator.propertyName : undefined;

    const objectSchema = this.codeModel.schemas.add(
      new ObjectSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
        minProperties: schema.minProperties ? Number(schema.minProperties) : undefined,
        maxProperties: schema.maxProperties ? Number(schema.maxProperties) : undefined,
        language: {
          default: {
            summary: schema.summary || schema.title,
          },
        },
      }),
    );

    // cache this now before we accidentally recurse on this type.
    this.schemaCache.set(schema, objectSchema);
    for (const { key: propertyName, value: propertyDeclaration } of items(schema.properties)) {
      const property = this.resolve(propertyDeclaration);
      this.use(<OpenAPI.Refable<OpenAPI.Schema>>propertyDeclaration, (pSchemaName, pSchema) => {
        const pType = this.processSchema(pSchemaName || `type·for·${propertyName}`, pSchema);
        const prop = objectSchema.addProperty(
          new Property(
            this.interpret.getPreferredName(propertyDeclaration, propertyName),
            propertyDeclaration.description ||
              this.interpret.getDescription(pType.language.default.description, property),
            pType,
            {
              readOnly: propertyDeclaration.readOnly || pSchema.readOnly,
              nullable: propertyDeclaration.nullable || pSchema.nullable,
              required: schema.required ? schema.required.indexOf(propertyName) > -1 : undefined,
              serializedName: propertyName,
              isDiscriminator: discriminatorProperty === propertyName ? true : undefined,
              extensions: this.interpret.getExtensionProperties(property, propertyDeclaration),
              clientDefaultValue: this.interpret.getClientDefault(property.instance, propertyDeclaration),
            },
          ),
        );
        if (prop.isDiscriminator) {
          objectSchema.discriminator = new Discriminator(prop);
        }
      });
    }

    return objectSchema;
  }

  processObjectSchema(
    name: string,
    schema: OpenAPI.Schema,
  ): ObjectSchema | DictionarySchema | OrSchema | XorSchema | AnySchema {
    const dictionaryDef = schema.additionalProperties;

    // is this more than a straightforward object?
    const parentCount = length(schema.allOf);
    const isMoreThanObject = parentCount + length(schema.anyOf) + length(schema.oneOf) > 0 || !!dictionaryDef;

    // do we have properties at all?
    const hasProperties = length(schema.properties) > 0;

    if (!isMoreThanObject && !hasProperties) {
      // it's an empty object?
      // this.session.warning(`Schema '${name}' is an empty object without properties or modifiers.`, ['Modeler', 'EmptyObject'], aSchema);
      return this.anyObjectSchema;
    }

    const dictionarySchema = dictionaryDef ? this.processDictionarySchema(name, schema) : undefined;
    if (parentCount === 0 && !hasProperties && dictionarySchema) {
      return dictionarySchema;
    }

    const objectSchema = this.createObjectSchema(name, schema);

    let i = 0;
    const parents: Array<ComplexSchema> = <any>values(schema.allOf)
      .select((sch) =>
        this.use(sch, (n, s) => {
          return this.processSchema(n || `${name}.allOf.${i++}`, s);
        }),
      )
      .toArray();
    const orTypes = values(schema.anyOf)
      .select((sch) =>
        this.use(sch, (n, s) => {
          return this.processSchema(n || `${name}.anyOf.${i++}`, s);
        }),
      )
      .toArray();
    const xorTypes = values(schema.oneOf)
      .select((sch) =>
        this.use(sch, (n, s) => {
          return this.processSchema(n || `${name}.oneOf.${i++}`, s);
        }),
      )
      .toArray();

    // add it to the upcoming and schema set
    // andTypes.unshift(objectSchema);

    // set the apiversion namespace
    const m = minimum(
      values(objectSchema.apiVersions)
        .select((each) => each.version)
        .toArray(),
    );
    objectSchema.language.default.namespace = this.useModelNamespace ? pascalCase(`Api ${m}`, false) : "";

    // tell it should be internal if possible
    // objectSchema.language.default.internal = true;

    if (dictionarySchema) {
      if (!hasProperties && parents.length === 0 && xorTypes.length === 0 && orTypes.length === 0) {
        return dictionarySchema;
      }
      // otherwise, we're combining
      parents.push(dictionarySchema);
    }

    if (parents.length > 0 && xorTypes.length === 0 && orTypes.length === 0) {
      // craft the and type for the model.
      const discriminator = this.findPolymorphicDiscriminator(schema);
      objectSchema.discriminatorValue = discriminator
        ? this.findDiscriminatorValue(discriminator, name, schema)
        : undefined;
      objectSchema.parents = new Relations();
      objectSchema.parents.immediate = parents;

      for (const p of parents) {
        if (p.type === SchemaType.Object) {
          const parent = <ObjectSchema>p;
          const grandparents = parent.parents?.all || [];
          const allParents = [...parents, ...grandparents];
          for (const myParent of parents) {
            if (grandparents.indexOf(myParent) > -1) {
              this.session.error(
                `The schema ${myParent.language.default.name} is already referenced in an allOf by ${parent.language.default.name} (or one of its parents)`,
                ["Modeler", "DuplicateParentReference"],
              );
            }
          }
          pushDistinct(objectSchema.parents.all, ...allParents);

          parent.children = parent.children || new Relations();
          pushDistinct(parent.children.immediate, objectSchema);
          pushDistinct(parent.children.all, objectSchema);

          for (const pp of grandparents) {
            if (pp.type === SchemaType.Object) {
              const pparent = <ObjectSchema>pp;
              pparent.children = pparent.children || new Relations();
              pushDistinct(pparent.children.all, objectSchema);
              if (pparent.discriminator && objectSchema.discriminatorValue) {
                pparent.discriminator.all[objectSchema.discriminatorValue] = objectSchema;
                // make sure parent has a discriminator, because grandparent does.
                parent.discriminator = parent.discriminator || new Discriminator(pparent.discriminator.property);
              }
            }
          }

          if (parent.discriminator && objectSchema.discriminatorValue) {
            parent.discriminator.immediate[objectSchema.discriminatorValue] = objectSchema;
            parent.discriminator.all[objectSchema.discriminatorValue] = objectSchema;
          }
        } else {
          pushDistinct(objectSchema.parents.all, p);
        }
      }
    }
    return objectSchema;
  }

  private findDiscriminatorValue(discriminator: OpenAPI.Discriminator, name: string, schema: OpenAPI.Schema): string {
    if (schema["x-ms-discriminator-value"]) {
      return schema["x-ms-discriminator-value"];
    }

    const mappedValue = discriminator.mapping
      ? this.findDiscriminatorValueFromMapping(name, discriminator.mapping)
      : undefined;

    return mappedValue ?? this.interpret.getName(name, schema);
  }

  private findDiscriminatorValueFromMapping(name: string, mapping: { [key: string]: string }): string | undefined {
    const entry = Object.entries(mapping).find(([_, ref]) => ref === `#/components/schemas/${name}`);
    return entry?.[0];
  }

  processOdataSchema(name: string, schema: OpenAPI.Schema): ODataQuerySchema {
    throw new Error("Method not implemented.");
  }

  processUnixTimeSchema(name: string, schema: OpenAPI.Schema): UnixTimeSchema {
    return this.codeModel.schemas.add(
      new UnixTimeSchema(this.interpret.getName(name, schema), this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        defaultValue: schema.default,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
        serialization: this.interpret.getSerialization(schema),
      }),
    );
  }

  processBinarySchema(name: string, schema: OpenAPI.Schema): BinarySchema {
    return this.codeModel.schemas.add(
      new BinarySchema(this.interpret.getDescription("", schema), {
        extensions: this.interpret.getExtensionProperties(schema),
        summary: schema.title,
        deprecated: this.interpret.getDeprecation(schema),
        apiVersions: this.interpret.getApiVersions(schema),
        example: this.interpret.getExample(schema),
        externalDocs: this.interpret.getExternalDocs(schema),
      }),
    );
  }

  processSchema(name: string, schema: OpenAPI.Schema): Schema {
    return this.schemaCache.process(schema, name) || fail("Unable to process schema.");
  }

  trap = new Set();

  processSchemaImpl(schema: OpenAPI.Schema, name: string): Schema {
    if (this.trap.has(schema)) {
      throw new Error(
        `RECURSING!  Saw schema ${schema.title || schema["x-ms-metadata"]?.name || name} more than once.`,
      );
    }
    this.trap.add(schema);

    const parents = schema.allOf?.map((x) => this.use(x, (n, i) => this.processSchema(n, i)));

    // handle enums differently early
    if (
      schema.enum ||
      schema["x-ms-enum"] ||
      parents?.find((x) => x.type === SchemaType.SealedChoice || x.type === SchemaType.Choice)
    ) {
      return this.processChoiceSchema(name, schema);
    }

    if (isSchemaBinary(schema)) {
      // handle inconsistency in file format handling.
      this.session.hint(
        `'The schema ${schema?.["x-ms-metadata"]?.name || name} with 'type: ${schema.type}', format: ${
          schema.format
        }' will be treated as a binary blob for binary media types.`,
        ["Modeler", "Superflous type information"],
        schema,
      );
      schema.type = OpenAPI.JsonType.String;
      schema.format = StringFormat.Binary;
    }

    // if they haven't set the schema.type then we're going to have to guess what
    // they meant to do.
    switch (schema.type) {
      case undefined:
      case null:
        if (schema.properties) {
          // if the model has properties, then we're going to assume they meant to say JsonType.object
          // but we're going to warn them anyway.

          this.session.warning(
            `The schema '${
              schema?.["x-ms-metadata"]?.name || name
            }' with an undefined type and declared properties is a bit ambiguous. This has been auto-corrected to 'type:object'`,
            ["Modeler", "MissingType"],
            schema,
          );
          schema.type = OpenAPI.JsonType.Object;
          break;
        }

        if (schema.additionalProperties) {
          // this looks like it's going to be a dictionary
          // we'll mark it as object and let the processObjectSchema sort it out.
          this.session.warning(
            `The schema '${
              schema?.["x-ms-metadata"]?.name || name
            }' with an undefined type and additionalProperties is a bit ambiguous. This has been auto-corrected to 'type:object'`,
            ["Modeler"],
            schema,
          );
          schema.type = OpenAPI.JsonType.Object;
          break;
        }

        if (schema.allOf || schema.anyOf || schema.oneOf) {
          // if the model has properties, then we're going to assume they meant to say JsonType.object
          // but we're going to warn them anyway.
          this.session.warning(
            `The schema '${
              schema?.["x-ms-metadata"]?.name || name
            }' with an undefined type and 'allOf'/'anyOf'/'oneOf' is a bit ambiguous. This has been auto-corrected to 'type:object'`,
            ["Modeler", "MissingType"],
            schema,
          );
          schema.type = OpenAPI.JsonType.Object;
          break;
        }

        {
          // no type info at all!?
          // const err = `The schema '${name}' has no type or format information whatsoever. ${this.location(schema)}`;
          this.session.warning(
            `The schema '${
              schema?.["x-ms-metadata"]?.name || name
            }' has no type or format information whatsoever. ${this.location(schema)}`,
            ["Modeler", "MissingType"],
            schema,
          );
          // throw Error(err);
          return this.anySchema;
        }
    }

    // ok, figure out what kind of schema this is.
    switch (schema.type) {
      case JsonType.Array:
        switch (schema.format) {
          case undefined:
            return this.processArraySchema(name, schema);
          default:
            this.session.error(
              `Array schema '${schema?.["x-ms-metadata"]?.name || name}' with unknown format: '${
                schema.format
              } ' is not valid`,
              ["Modeler"],
              schema,
            );
        }
        break;

      case JsonType.Boolean:
        switch (schema.format) {
          case undefined:
            return this.processBooleanSchema(name, schema);
          default:
            this.session.error(
              `Boolean schema '${name}' with unknown format: '${schema.format}' is not valid`,
              ["Modeler"],
              schema,
            );
        }
        break;

      case JsonType.Integer:
        schema.format = schema.format ? schema.format.toLowerCase() : schema.format;
        switch (schema.format) {
          case IntegerFormat.UnixTime:
            return this.processUnixTimeSchema(name, schema);

          case IntegerFormat.Int64:
          case IntegerFormat.Int32:
          case IntegerFormat.None:
          case undefined:
            return this.processIntegerSchema(name, schema);

          case NumberFormat.Double:
          case NumberFormat.Float:
          case NumberFormat.Decimal:
            return this.processNumberSchema(name, schema);

          default:
            // According to the OpenAPI v3 spec, an unexpected format should be ignored,
            // so treat this as an `integer` with no format.
            this.session.warning(
              `Integer schema '${name}' with unknown format: '${schema.format}' is not valid.  Treating it as 'int32'.`,
              ["Modeler"],
              schema,
            );
            return this.processIntegerSchema(name, schema);
        }

      case JsonType.Number:
        switch (schema.format) {
          case undefined:
          case NumberFormat.None:
          case NumberFormat.Double:
          case NumberFormat.Float:
          case NumberFormat.Decimal:
            return this.processNumberSchema(name, schema);

          case IntegerFormat.Int64:
          case IntegerFormat.Int32:
            return this.processIntegerSchema(name, schema);

          default:
            this.session.error(
              `Number schema '${name}' with unknown format: '${schema.format}' is not valid`,
              ["Modeler"],
              schema,
            );
        }
        break;

      case JsonType.Object:
        return this.processObjectSchema(name, schema);

      case JsonType.String:
        switch (schema.format) {
          // member should be byte array
          // on wire format should be base64url
          case StringFormat.Base64Url:
          case StringFormat.Byte:
          case StringFormat.Certificate:
            return this.processByteArraySchema(name, schema);

          case StringFormat.Binary:
            // represent as a binary
            // wire format is stream of bytes
            // This is actually a different kind of response or request
            // and should not be treated as a trivial 'type'
            return this.processBinarySchema(name, schema);

          case StringFormat.Char:
            // a single character
            return this.processCharacterSchema(name, schema);

          case StringFormat.Date:
            return this.processDateSchema(name, schema);

          case StringFormat.Time:
            return this.processTimeSchema(name, schema);

          case StringFormat.DateTime:
          case StringFormat.DateTimeRfc1123:
            return this.processDateTimeSchema(name, schema);

          case StringFormat.Duration:
            return this.processDurationSchema(name, schema);

          case StringFormat.Uuid:
            return this.processUuidSchema(name, schema);

          case StringFormat.Url:
            return this.processUriSchema(name, schema);

          case StringFormat.Password:
            return this.processCredentialSchema(name, schema);

          case StringFormat.OData:
            return this.processOdataSchema(name, schema);

          case StringFormat.None:
          case undefined:
          case null:
            return this.processStringSchema(name, schema);

          default:
            // console.error(`String schema '${name}' with unknown format: '${schema.format}' is treated as simple string.`);
            return this.processStringSchema(name, schema);

          //              this.session.error(`String schema '${name}' with unknown format: '${schema.format}' is not valid`, ['Modeler'], schema);
        }
    }
    this.session.error(
      `The model ${name} does not have a recognized schema type '${schema.type}' ${JSON.stringify(schema)} `,
      ["Modeler", "UnknownSchemaType"],
    );
    throw new Error(`Unrecognized schema type:'${schema.type}' / format: ${schema.format} ${JSON.stringify(schema)} `);
  }

  filterMediaTypes(oai3Content: Dictionary<MediaType> | undefined) {
    const mediaTypeGroups = this.bodyProcessor.groupMediaTypes(oai3Content);

    // filter out invalid combinations
    //if (length(mediaTypeGroups.keys()) > 0) {
    // because the oai2-to-oai3 conversion doesn't have good logic to know
    // which produces type maps to each operation response,
    // we have to go thru the possible combinations
    // and eliminate ones that don't make sense.
    // (ie, a binary media type should have a binary response type, a json or xml media type should have a <not binary> type ).
    for (const [knownMediaType, mt] of [...mediaTypeGroups.entries()]) {
      for (const fmt of mt) {
        if (this.interpret.isBinarySchema(fmt.schema.instance)) {
          // if the schema really says 'type: file', we have to accept all the formats
          // that were listed in the original 'produces' collection
          // because we *can't* infer that a json/xml/form media type means deserialize

          switch (knownMediaType) {
            case KnownMediaType.Json:
            case KnownMediaType.Xml:
            case KnownMediaType.Form:
              // it's been mis-categorized as a deserialization
              // but they said,"stream please"
              // then we have to move it to the binary bucket.
              // eslint-disable-next-line no-case-declarations
              let b = mediaTypeGroups.get(KnownMediaType.Binary);
              if (!b) {
                // we don't have a binary group at all.
                // let's just create one
                b = [];
                mediaTypeGroups.set(KnownMediaType.Binary, b);
              }
              b.push(fmt);
              // remove the current group
              mediaTypeGroups.delete(knownMediaType);
          }
        } else {
          switch (knownMediaType) {
            case KnownMediaType.Json:
            case KnownMediaType.Xml:
            case KnownMediaType.Form:
              if (!fmt.schema) {
                // is this a good check?
                throw new Error(
                  `Object Response ${knownMediaType}:${fmt.mediaType} has no schema for the response, and can't deserialize.`,
                );
              }
              // if the schema is binary, then it shouldn't be an object deserialization step. (oai2-to-oai3 upconversion ugly)
              if (this.interpret.isBinarySchema(fmt.schema.instance)) {
                // bad combo, remove.
                mediaTypeGroups.delete(knownMediaType);
                continue;
              }
              break;
            case KnownMediaType.Binary:
            case KnownMediaType.Text:
              if (!fmt.schema.instance) {
                // if we don't have a schema at all, should we infer a binary schema anyway?
                // dunno.
              }

              if (
                !(knownMediaType === KnownMediaType.Text && fmt.schema.instance?.type === JsonType.String) &&
                !this.interpret.isBinarySchema(fmt.schema.instance)
              ) {
                // bad combo, remove.
                mediaTypeGroups.delete(knownMediaType);
                continue;
              }
              break;

            default:
              throw new Error(`Not able to process media type ${fmt.mediaType} at this moment.`);
          }
        }
      }
    }
    // }
    return mediaTypeGroups;
  }

  getUniqueName(baseName: string): string {
    let nameCount = this.uniqueNames[baseName];
    if (typeof nameCount == "number") {
      this.uniqueNames[baseName] = nameCount++;
      return `${baseName}${nameCount}`;
    } else {
      this.uniqueNames[baseName] = 0;
      return baseName;
    }
  }

  getContentTypeParameterSchema(http: HttpWithBodyRequest, alwaysConstant = false) {
    if (http.mediaTypes.length === 1 || alwaysConstant) {
      return this.codeModel.schemas.add(
        new ConstantSchema(http.mediaTypes[0], `Content Type '${http.mediaTypes[0]}'`, {
          valueType: this.stringSchema,
          value: new ConstantValue(http.mediaTypes[0]),
        }),
      );
    }
    const choices = http.mediaTypes.sort().map((each) => new ChoiceValue(each, `Content Type '${each}'`, each));
    const check = JSON.stringify(choices);

    // look for a sealed choice schema with that set of choices
    return (
      this.codeModel.schemas.sealedChoices?.find((each) => JSON.stringify(each.choices) === check) ||
      this.codeModel.schemas.add(
        new SealedChoiceSchema(this.getUniqueName("ContentType"), "Content type for upload", {
          choiceType: this.stringSchema,
          choices,
        }),
      )
    );
  }

  getAcceptParameterSchema(mediaTypes: Array<string>) {
    const acceptTypes = mediaTypes.join(", ");
    return (
      this.codeModel.schemas.constants?.find(
        (each) => each.language.default.name === "Accept" && each.value.value === acceptTypes,
      ) ||
      this.codeModel.schemas.add(
        new ConstantSchema(this.getUniqueName("Accept"), `Accept: ${acceptTypes}`, {
          valueType: this.stringSchema,
          value: new ConstantValue(acceptTypes),
        }),
      )
    );
  }

  processBinary(
    kmt: KnownMediaType,
    kmtBinary: Array<{ mediaType: string; schema: Dereferenced<OpenAPI.Schema | undefined> }>,
    operation: Operation,
    body: Dereferenced<OpenAPI.RequestBody | undefined>,
  ) {
    const http = new HttpBinaryRequest({
      knownMediaType: kmt,
      mediaTypes: kmtBinary.map((each) => each.mediaType),
      binary: true,
    });

    // create the request object
    const httpRequest = new Request({
      protocol: {
        http,
      },
    });

    const shouldIncludeContentType =
      this.options[`always-create-content-type-parameter`] === true || http.mediaTypes.length > 1;

    if (!isContentTypeParameterDefined(operation) && shouldIncludeContentType) {
      const scs = this.getContentTypeParameterSchema(http);

      // add the parameter for the binary upload.
      httpRequest.addParameter(
        new Parameter("content-type", "Upload file type", scs, {
          implementation: ImplementationLocation.Method,
          required: true,
          origin: "modelerfour:synthesized/content-type",

          language: {
            default: {
              serializedName: "Content-Type",
            },
          },
          protocol: {
            http: new HttpParameter(ParameterLocation.Header),
          },
        }),
      );
    }

    const bodyName = body.instance?.["x-ms-requestBody-name"] ?? "data";

    const requestSchema = values(kmtBinary).first((each) => !!each.schema.instance)?.schema;

    const pSchema =
      kmt === KnownMediaType.Text
        ? this.stringSchema
        : this.processBinarySchema(requestSchema?.name || "upload", requestSchema?.instance || <OpenAPI.Schema>{});
    // add a stream parameter for the body
    httpRequest.addParameter(
      new Parameter(bodyName, this.interpret.getDescription("", body?.instance || {}), pSchema, {
        extensions: this.interpret.getExtensionProperties(body?.instance || {}),
        protocol: {
          http: new HttpParameter(ParameterLocation.Body, {
            style: SerializationStyle.Binary,
          }),
        },
        implementation: ImplementationLocation.Method,
        required: body.instance?.required,
        nullable: requestSchema?.instance?.nullable,
        clientDefaultValue: this.interpret.getClientDefault(body?.instance || {}, {}),
      }),
    );

    return operation.addRequest(httpRequest);
  }

  processSerializedObject(
    kmt: KnownMediaType,
    kmtObject: Array<{ mediaType: string; schema: Dereferenced<OpenAPI.Schema | undefined> }>,
    operation: Operation,
    body: Dereferenced<OpenAPI.RequestBody | undefined>,
  ) {
    if (!body?.instance) {
      throw new Error("NO BODY DUDE.");
    }

    const http: HttpWithBodyRequest =
      kmt === KnownMediaType.Multipart
        ? new HttpMultipartRequest({
            knownMediaType: kmt,
            mediaTypes: ["multipart/form-data"],
          })
        : new HttpWithBodyRequest({
            knownMediaType: kmt,
            mediaTypes: kmtObject.map((each) => each.mediaType),
          });

    // create the request object
    const httpRequest = new Request({
      protocol: {
        http,
      },
    });

    if (!isContentTypeParameterDefined(operation) && this.options[`always-create-content-type-parameter`] === true) {
      const scs = this.getContentTypeParameterSchema(http, true);

      // add the parameter for the binary upload.
      httpRequest.addParameter(
        new Parameter("content-type", "Body Parameter content-type", scs, {
          implementation: ImplementationLocation.Method,
          required: true,
          origin: "modelerfour:synthesized/content-type",
          protocol: {
            http: new HttpParameter(ParameterLocation.Header),
          },
          language: {
            default: {
              serializedName: "Content-Type",
            },
          },
        }),
      );
    }

    const requestSchema = values(kmtObject).first((each) => !!each.schema.instance)?.schema;

    if (kmt === KnownMediaType.Multipart || kmt === KnownMediaType.Form) {
      if (!requestSchema || !requestSchema.instance) {
        throw new Error("Cannot process a multipart/form-data body without a schema.");
      }

      // Convert schema properties into parameters.  OpenAPI 3 requires that
      // multipart/form-data parameters be modeled as object schema properties
      // but we must turn them back into operation parameters so that code
      // generators will generate them as method parameters.
      for (const { key: propertyName, value: propertyDeclaration } of items(requestSchema.instance.properties)) {
        const property = this.resolve(propertyDeclaration);
        this.use(<OpenAPI.Refable<OpenAPI.Schema>>propertyDeclaration, (pSchemaName, pSchema) => {
          const pType = this.processSchema(pSchemaName || `type·for·${propertyName}`, pSchema);
          httpRequest.addParameter(
            new Parameter(
              propertyName,
              propertyDeclaration.description ||
                this.interpret.getDescription(pType.language.default.description, property),
              pType,
              {
                schema: pType,
                required:
                  requestSchema.instance?.required && requestSchema.instance?.required.indexOf(propertyName) > -1
                    ? true
                    : undefined,
                implementation: ImplementationLocation.Method,
                extensions: this.interpret.getExtensionProperties(propertyDeclaration),
                nullable: propertyDeclaration.nullable || pSchema.nullable,
                protocol: {
                  http: new HttpParameter(ParameterLocation.Body),
                },
                language: {
                  default: {
                    name: propertyName,
                    description: propertyDeclaration.description,
                    serializedName: propertyName,
                  },
                },
                clientDefaultValue: this.interpret.getClientDefault(propertyDeclaration, pSchema),
                isPartialBody: true,
              },
            ),
          );

          // Track the usage of this schema as an input with media type
          this.trackSchemaUsage(pType, { usage: [SchemaContext.Input], serializationFormats: [kmt] });
        });
      }
    } else {
      const pSchema = this.processSchema(
        requestSchema?.name || "requestBody",
        requestSchema?.instance || <OpenAPI.Schema>{},
      );

      // Track the usage of this schema as an input with media type
      this.trackSchemaUsage(pSchema, { usage: [SchemaContext.Input], serializationFormats: [kmt] });

      httpRequest.addParameter(
        new Parameter(
          body.instance?.["x-ms-requestBody-name"] ?? "body",
          this.interpret.getDescription("", body?.instance || {}),
          pSchema,
          {
            extensions: this.interpret.getExtensionProperties(body.instance),
            required: !!body.instance.required,
            nullable: requestSchema?.instance?.nullable,
            protocol: {
              http: new HttpParameter(ParameterLocation.Body, {
                style: <SerializationStyle>(<any>kmt),
              }),
            },
            implementation: ImplementationLocation.Method,
            clientDefaultValue: this.interpret.getClientDefault(body?.instance || {}, {}),
          },
        ),
      );
    }

    return operation.addRequest(httpRequest);
  }

  processOperation(httpOperation: OpenAPI.HttpOperation, method: string, path: string, pathItem: OpenAPI.PathItem) {
    const p = path.indexOf("?");
    path = p > -1 ? path.substr(0, p) : path;

    // get group and operation name
    const { group, member } = this.interpret.getOperationId(method, path, httpOperation);
    const memberName = httpOperation["x-ms-client-name"] ?? member;
    const operationGroup = this.codeModel.getOperationGroup(group);
    const operation = operationGroup.addOperation(
      new Operation(memberName, this.interpret.getDescription("", httpOperation), {
        extensions: this.interpret.getExtensionProperties(httpOperation),
        apiVersions: this.interpret.getApiVersions(pathItem),
        deprecated: this.interpret.getDeprecation(httpOperation),
        language: {
          default: {
            summary: httpOperation.summary,
          },
        },
      }),
    );

    // tag the pageable operation with pagable info and the linked operation if specified.
    if (httpOperation["x-ms-pageable"]) {
      const nextLink = httpOperation["x-ms-pageable"]?.operationName;
      operation.language.default.paging = {
        ...httpOperation["x-ms-pageable"],
        ...(nextLink ? this.interpret.splitOpId(nextLink) : {}),
        operationName: nextLink ? undefined : httpOperation["x-ms-pageable"].opearationName,
      };
    }

    // === Host Parameters ===
    const baseUri = this.processHostParameters(httpOperation, operation, path, pathItem);

    // === Common Parameters ===
    this.processParameters(httpOperation, operation, pathItem);

    // === Requests ===
    this.processRequestBody(httpOperation, method, operationGroup, operation, path, baseUri);

    // === Response ===
    this.processResponses(httpOperation, operation);
  }

  processHostParameters(
    httpOperation: OpenAPI.HttpOperation,
    operation: Operation,
    path: string,
    pathItem: OpenAPI.PathItem,
  ) {
    let baseUri = "";
    // create $host parameters from servers information.
    // $host is comprised of []
    const servers = values(httpOperation.servers).toArray();

    switch (servers.length) {
      case 0:
        // Yanni says "we're ignoring the swagger spec because it is stupid."
        servers.push({
          url: "",
          variables: {},
          description: "Service Host URL.",
        });

      // eslint-disable-next-line no-fallthrough
      case 1:
        {
          const server = servers[0];
          // trim extraneous slash .
          const uri =
            server.url.endsWith("/") && path.startsWith("/") ? server.url.substr(0, server.url.length - 1) : server.url;

          if (length(server.variables) === 0) {
            // scenario 1 : single static value

            // check if we have the $host parameter foor this uri yet.
            operation.addParameter(
              this.codeModel.addGlobalParameter(
                (each) => each.language.default.name === "$host" && each.clientDefaultValue === uri,
                () =>
                  new Parameter("$host", "server parameter", this.stringSchema, {
                    required: true,
                    origin: "modelerfour:synthesized/host",
                    implementation: ImplementationLocation.Client,
                    protocol: {
                      http: new HttpParameter(ParameterLocation.Uri),
                    },
                    clientDefaultValue: uri,
                    language: {
                      default: {
                        serializedName: "$host",
                      },
                    },
                    extensions: {
                      "x-ms-skip-url-encoding": true,
                    },
                  }),
              ),
            );
            // and update the path for the operation.
            baseUri = "{$host}";
          } else {
            // scenario 3 : single parameterized value

            for (const { key: variableName, value: variable } of items(server.variables).where((each) => !!each.key)) {
              const sch = this.getServerVariableSchema(variableName, variable);

              const clientdefault = variable.default ? variable.default : undefined;

              // figure out where the parameter is supposed to be.
              const implementation =
                variable["x-ms-parameter-location"] === "client"
                  ? ImplementationLocation.Client
                  : ImplementationLocation.Method;

              let p =
                implementation === ImplementationLocation.Client
                  ? this.codeModel.findGlobalParameter(
                      (each) =>
                        each.language.default.name === variableName && each.clientDefaultValue === clientdefault,
                    )
                  : undefined;

              const originalParameter = this.resolve<OpenAPI.Parameter>(variable["x-ms-original"]);

              if (!p) {
                p = new Parameter(variableName, variable.description || `${variableName} - server parameter`, sch, {
                  required: true,
                  implementation,
                  protocol: {
                    http: new HttpParameter(ParameterLocation.Uri),
                  },
                  language: {
                    default: {
                      serializedName: variableName,
                    },
                  },
                  extensions: {
                    ...this.interpret.getExtensionProperties(variable),
                    "x-ms-priority": originalParameter?.instance?.["x-ms-priority"],
                  },
                  clientDefaultValue: clientdefault,
                });
                if (implementation === ImplementationLocation.Client) {
                  // add it to the global parameter list (if it's a client parameter)
                  this.codeModel.addGlobalParameter(p);
                }
              }
              // add the parameter to the operaiton
              operation.addParameter(p);
            }
            // and update the path for the operation. (copy the template onto the path)
            // path = `${uri}${path}`;
            baseUri = uri;
          }
        }
        break;

      default: {
        if (values(servers).any((each) => length(each.variables) > 0)) {
          // scenario 4 : multiple parameterized value - not valid.
          throw new Error(
            `Operation ${pathItem?.["x-ms-metadata"]?.path} has multiple server information with parameterized values.`,
          );
        }
        const sss = servers.join(",");
        const choiceSchema =
          this.codeModel.schemas.choices?.find(
            (each) => each.choices.map((choice) => choice.value).join(",") === sss,
          ) ||
          this.codeModel.schemas.add(
            new ChoiceSchema("host-options", "choices for server host", {
              choices: servers.map((each) => new ChoiceValue(each.url, `host: ${each.url}`, each.url)),
              choiceType: this.stringSchema,
            }),
          );

        // scenario 2 : multiple static value
        operation.addParameter(
          this.codeModel.addGlobalParameter(
            (each) => each.language.default.name === "$host" && each.clientDefaultValue === servers[0].url,
            () =>
              new Parameter("$host", "server parameter", choiceSchema, {
                required: true,
                implementation: ImplementationLocation.Client,
                origin: "modelerfour:synthesized/host",
                protocol: {
                  http: new HttpParameter(ParameterLocation.Uri),
                },
                language: {
                  default: {
                    serializedName: "$host",
                  },
                },
                extensions: {
                  "x-ms-skip-url-encoding": true,
                },
                clientDefaultValue: servers[0].url,
              }),
          ),
        );

        // update the path to have a $host parameter.
        //path = `{$host}${path}`;
        baseUri = "{$host}";
      }
    }
    return baseUri;
  }

  private getServerVariableSchema(variableName: string, variable: OpenAPI.ServerVariable) {
    if (variable.enum) {
      return this.processChoiceSchema(variableName, <OpenAPI.Schema>{
        type: "string",
        enum: variable.enum,
        description: variable.description || `${variableName} - server parameter`,
      });
    }

    if (variable["x-format"]) {
      return this.processSchema(`${variableName}`, {
        type: JsonType.String,
        format: variable["x-format"],
      });
    }
    return this.stringSchema;
  }
  processApiVersionParameterForProfile() {
    throw new Error("Profile Support for API Verison Parameters not implemented.");
  }

  addApiVersionParameter(
    parameter: OpenAPI.Parameter,
    operation: Operation,
    pathItem: OpenAPI.PathItem,
    apiVersionParameterSchema: ChoiceSchema | ConstantSchema,
  ) {
    const p = new Parameter("ApiVersion", "Api Version", apiVersionParameterSchema, {
      required: parameter.required ? true : undefined,
      origin: "modelerfour:synthesized/api-version",
      protocol: {
        http: new HttpParameter(ParameterLocation.Query),
      },
      language: {
        default: {
          serializedName: parameter.name,
        },
      },
    });

    switch (this.apiVersionMode) {
      case "method":
        p.implementation = ImplementationLocation.Method;
        return operation.addParameter(p);

      case "client":
        // eslint-disable-next-line no-case-declarations
        let pp = this.codeModel.findGlobalParameter((each) => each.language.default.name === "ApiVersion");
        if (!pp) {
          p.implementation = ImplementationLocation.Client;
          pp = this.codeModel.addGlobalParameter(p);
        }
        return operation.addParameter(pp);
    }
    throw new Error(`addApiVersionParameter : Invalid state api-version-mode: '${this.apiVersionMode}'`);
  }

  processChoiceApiVersionParameter(
    parameter: OpenAPI.Parameter,
    operation: Operation,
    pathItem: OpenAPI.PathItem,
    apiversions: Array<string>,
  ) {
    const apiVersionChoice = this.codeModel.schemas.add(
      new ChoiceSchema(`ApiVersion-${apiversions[0]}`, `Api Versions`, {
        choiceType: this.stringSchema,
        choices: apiversions.map((each) => new ChoiceValue(each, `Api Version '${each}'`, each)),
      }),
    );

    return this.addApiVersionParameter(parameter, operation, pathItem, apiVersionChoice);
  }

  processConstantApiVersionParameter(
    parameter: OpenAPI.Parameter,
    operation: Operation,
    pathItem: OpenAPI.PathItem,
    apiversions: Array<string>,
  ) {
    if (apiversions.length > 1) {
      throw new Error(
        `Operation ${pathItem?.["x-ms-metadata"]?.path} has more than one ApiVersion possibility, but 'api-version-parameter'='constant' `,
      );
    }
    const apiVersionConst = this.codeModel.schemas.add(
      new ConstantSchema(`ApiVersion-${apiversions[0]}`, `Api Version (${apiversions[0]})`, {
        valueType: this.stringSchema,
        value: new ConstantValue(apiversions[0]),
      }),
    );

    return this.addApiVersionParameter(parameter, operation, pathItem, apiVersionConst);
  }

  processApiVersionParameter(parameter: OpenAPI.Parameter, operation: Operation, pathItem: OpenAPI.PathItem) {
    const apiversions = this.interpret.getApiVersionValues(pathItem);
    if (apiversions.length === 0) {
      // !!!
      throw new Error(
        `Operation ${pathItem?.["x-ms-metadata"]?.path} has no apiversions but has an apiversion parameter.`,
      );
    }

    if (this.apiVersionMode === "profile") {
      return this.processApiVersionParameterForProfile();
    }

    switch (this.apiVersionParameter) {
      case "constant":
        return this.processConstantApiVersionParameter(parameter, operation, pathItem, apiversions);

      case "choice":
        return this.processChoiceApiVersionParameter(parameter, operation, pathItem, apiversions);
    }

    throw new Error(`Invalid api-version-parameter: ${this.apiVersionParameter}`);
  }

  processParameters(httpOperation: OpenAPI.HttpOperation, operation: Operation, pathItem: OpenAPI.PathItem) {
    values(httpOperation.parameters)
      .select((each) => dereference(this.input, each))
      .select((pp) => {
        const parameter = pp.instance;

        this.use(parameter.schema, (name, schema) => {
          if (this.apiVersionMode !== "none" && this.interpret.isApiVersionParameter(parameter)) {
            return this.processApiVersionParameter(parameter, operation, pathItem);
          }

          // Not an APIVersion Parameter
          const implementation = pp.fromRef
            ? "method" === <any>parameter["x-ms-parameter-location"]
              ? ImplementationLocation.Method
              : ImplementationLocation.Client
            : "client" === <any>parameter["x-ms-parameter-location"]
            ? ImplementationLocation.Client
            : ImplementationLocation.Method;

          const preferredName = this.interpret.getPreferredName(
            parameter,
            schema["x-ms-client-name"] || parameter.name,
          );
          if (implementation === ImplementationLocation.Client) {
            // check to see of it's already in the global parameters
            const p = this.codeModel.findGlobalParameter((each) => each.language.default.name === preferredName);
            if (p) {
              return operation.addParameter(p);
            }
          }
          let parameterSchema = this.processSchema(name || "", schema);

          // Track the usage of this schema as an input with media type
          this.trackSchemaUsage(parameterSchema, { usage: [SchemaContext.Input] });

          if (parameter.in === ParameterLocation.Header && "x-ms-header-collection-prefix" in parameter) {
            const dictionarySchema = this.codeModel.schemas.add(
              new DictionarySchema(
                parameterSchema.language.default.name,
                parameterSchema.language.default.description,
                parameterSchema,
              ),
            );
            this.trackSchemaUsage(dictionarySchema, { usage: [SchemaContext.Input] });
            parameterSchema = dictionarySchema;
          }

          /* regular, everyday parameter */
          const newParam = operation.addParameter(
            new Parameter(preferredName, this.interpret.getDescription("", parameter), parameterSchema, {
              required: parameter.required ? true : undefined,
              implementation,
              extensions: this.interpret.getExtensionProperties(parameter),
              deprecated: this.interpret.getDeprecation(parameter),
              nullable: parameter.nullable || schema.nullable,
              protocol: {
                http: new HttpParameter(
                  parameter.in,
                  parameter.style
                    ? {
                        style: <SerializationStyle>(<unknown>parameter.style),
                        explode: parameter.explode,
                      }
                    : undefined,
                ),
              },
              language: {
                default: {
                  serializedName: parameter.name,
                },
              },
              clientDefaultValue: this.interpret.getClientDefault(parameter, schema),
            }),
          );

          // if allowReserved is present, add the extension attribute too.
          if (parameter.allowReserved) {
            newParam.extensions = newParam.extensions ?? {};
            newParam.extensions["x-ms-skip-url-encoding"] = true;
          }

          if (implementation === ImplementationLocation.Client) {
            this.codeModel.addGlobalParameter(newParam);
          }

          return newParam;
        });
      })
      .toArray();
  }

  processResponses(httpOperation: OpenAPI.HttpOperation, operation: Operation) {
    const acceptTypes = new Set<string>();

    // === Response ===
    for (const { key: responseCode, value: response } of this.resolveDictionary(httpOperation.responses)) {
      const isErr = responseCode === "default" || response["x-ms-error-response"];

      const knownMediaTypes = this.filterMediaTypes(response.content);

      if (length(knownMediaTypes) === 0) {
        // it has no actual response *payload*
        // so we just want to create a simple response .
        const rsp = new Response({
          extensions: this.interpret.getExtensionProperties(response),
        });
        rsp.language.default.description = response.description;

        const headers = this.processResponseHeaders(response.headers);
        rsp.protocol.http = SetType(HttpResponse, {
          statusCodes: [responseCode],
          headers: headers.length ? headers : undefined,
        });
        if (isErr) {
          operation.addException(rsp);
        } else {
          operation.addResponse(rsp);
        }
      } else {
        for (const { key: knownMediaType, value: mediatypes } of items(knownMediaTypes)) {
          const allMt = mediatypes.map((each) => each.mediaType);
          for (const mediaType of allMt) {
            acceptTypes.add(mediaType);
          }

          const headers = this.processResponseHeaders(response.headers);

          if (knownMediaType === KnownMediaType.Binary) {
            // binary response needs different response type.
            const rsp = new BinaryResponse({
              extensions: this.interpret.getExtensionProperties(response),
            });
            rsp.language.default.description = response.description;
            rsp.protocol.http = SetType(HttpBinaryResponse, {
              statusCodes: [responseCode],
              knownMediaType: knownMediaType,
              mediaTypes: allMt,
              headers: headers.length ? headers : undefined,
            });
            if (isErr) {
              //op.addException(rsp);
              // errors should not be binary streams!
              throw new Error(`The response body should not be a binary! ${httpOperation.operationId}/${responseCode}`);
            } else {
              operation.addResponse(rsp);
            }
            continue;
          }

          const schema = mediatypes[0].schema.instance;

          if (schema) {
            let s = this.processSchema(mediatypes[0].schema.name || "response", schema);

            // response schemas should not be constant types.
            // this replaces the constant value with the value type itself.

            if (s.type === SchemaType.Constant) {
              s = (<ConstantSchema>s).valueType;
            }

            if (isErr) {
              // Track the usage of this schema as an exception with media type
              this.trackSchemaUsage(s, {
                usage: [SchemaContext.Exception],
                serializationFormats: [knownMediaType as KnownMediaType],
              });
            } else {
              // Track the usage of this schema as an output with media type
              this.trackSchemaUsage(s, {
                usage: [SchemaContext.Output],
                serializationFormats: [knownMediaType as KnownMediaType],
              });
            }

            const rsp = new SchemaResponse(s, {
              extensions: this.interpret.getExtensionProperties(response),
              nullable: schema.nullable,
            });
            rsp.language.default.description = response.description;

            rsp.protocol.http = SetType(HttpResponse, {
              statusCodes: [responseCode],
              knownMediaType: knownMediaType,
              mediaTypes: allMt,
              headers: headers.length ? headers : undefined,
            });

            if (isErr) {
              operation.addException(rsp);
            } else {
              operation.addResponse(rsp);
            }
          }
        }
      }
    }

    function isAcceptHeaderParam(p: Parameter): boolean {
      return p.protocol.http?.in === ParameterLocation.Header && p.language.default.serializedName === "Accept";
    }

    // Synthesize an 'Accept' header based on the media types in this
    // operation and add it to all requests.  Before adding the header,
    // make sure there isn't an existing Accept parameter.
    const mediaTypes = Array.from(acceptTypes);
    if (this.options["always-create-accept-parameter"] === true && acceptTypes.size > 0) {
      const acceptSchema = this.getAcceptParameterSchema(mediaTypes);
      if (!values(operation.parameters).first(isAcceptHeaderParam)) {
        for (const request of values(operation.requests)) {
          if (values(request.parameters).first(isAcceptHeaderParam)) {
            // Already has an accept parameter, move on to the next.
            continue;
          }

          request.addParameter(
            new Parameter("accept", "Accept header", acceptSchema, {
              implementation: ImplementationLocation.Method,
              required: true,
              origin: "modelerfour:synthesized/accept",
              protocol: {
                http: new HttpParameter(ParameterLocation.Header),
              },
              language: {
                default: {
                  serializedName: "Accept",
                },
              },
            }),
          );
        }
      }
    }
  }

  private processResponseHeaders(responseHeaders: Dictionary<Refable<OpenAPI.Header>> | undefined): HttpHeader[] {
    const headers: HttpHeader[] = [];
    for (const { key: headerName, value: header } of this.resolveDictionary(responseHeaders)) {
      this.use(header.schema, (_name, sch) => {
        let hsch = this.processSchema(this.interpret.getName(headerName, sch), sch);
        if ("x-ms-header-collection-prefix" in header) {
          const newSchema = new DictionarySchema(hsch.language.default.name, hsch.language.default.description, hsch);
          newSchema.language.default.header = headerName;
          const dictionarySchema = this.codeModel.schemas.add(newSchema);
          this.trackSchemaUsage(dictionarySchema, { usage: [SchemaContext.Input] });
          hsch = dictionarySchema;
        }

        hsch.language.default.header = headerName;
        headers.push(
          new HttpHeader(headerName, hsch, {
            extensions: this.interpret.getExtensionProperties(header),
            language: {
              default: {
                name: header["x-ms-client-name"] || headerName,
                description: this.interpret.getDescription("", header),
              },
            },
          }),
        );
      });
    }
    return headers;
  }

  processRequestBody(
    httpOperation: OpenAPI.HttpOperation,
    httpMethod: string,
    operationGroup: OperationGroup,
    operation: Operation,
    path: string,
    baseUri: string,
  ) {
    const requestBody = this.resolve(httpOperation.requestBody);
    if (requestBody.instance) {
      const groupedMediaTypes = this.bodyProcessor.groupMediaTypes(requestBody.instance.content);
      const kmtCount = groupedMediaTypes.size;
      switch (httpMethod.toLowerCase()) {
        case "get":
        case "head":
        case "delete":
          if (kmtCount > 0) {
            this.session.warning(
              `Operation '${operationGroup.language.default.name}/${operation.language.default.name}' really should not have a media type (because there should be no body)`,
              ["?"],
              httpOperation.requestBody,
            );
          }
          break;
        case "options":
        case "trace":
        case "put":
        case "patch":
        case "post":
          if (kmtCount === 0) {
            throw new Error(
              `Operation '${operationGroup.language.default.name}/${operation.language.default.name}' must have a media type.`,
            );
          }
      }

      const kmtBinary = groupedMediaTypes.get(KnownMediaType.Binary);
      const kmtJSON = groupedMediaTypes.get(KnownMediaType.Json);
      if (kmtBinary) {
        // handle binary
        this.processBinary(KnownMediaType.Binary, kmtBinary, operation, requestBody);
      }
      const kmtText = groupedMediaTypes.get(KnownMediaType.Text);
      if (kmtText) {
        this.processBinary(KnownMediaType.Text, kmtText, operation, requestBody);
      }
      if (kmtJSON) {
        this.processSerializedObject(KnownMediaType.Json, kmtJSON, operation, requestBody);
      }
      const kmtXML = groupedMediaTypes.get(KnownMediaType.Xml);
      if (kmtXML && !kmtJSON) {
        // only do XML if there is not a JSON body
        this.processSerializedObject(KnownMediaType.Xml, kmtXML, operation, requestBody);
      }
      const kmtForm = groupedMediaTypes.get(KnownMediaType.Form);
      if (kmtForm && !kmtXML && !kmtJSON) {
        // only do FORM if there is not an JSON or XML body
        this.processSerializedObject(KnownMediaType.Form, kmtForm, operation, requestBody);
      }
      const kmtMultipart = groupedMediaTypes.get(KnownMediaType.Multipart);
      if (kmtMultipart) {
        // create multipart form upload for this.
        this.processSerializedObject(KnownMediaType.Multipart, kmtMultipart, operation, requestBody);
      }
      // ensure the protocol information is set on the requests
      for (const request of values(operation.requests)) {
        is(request.protocol.http);
        request.protocol.http.method = httpMethod;
        request.protocol.http.path = path;
        request.protocol.http.uri = baseUri;
      }
    } else {
      // no request body present
      // which means there should just be a simple request with no parameters
      // added to the operation.
      operation.addRequest(
        new Request({
          protocol: {
            http: new HttpRequest({
              method: httpMethod,
              path: path,
              uri: baseUri,
            }),
          },
        }),
      );
    }
  }

  process() {
    this.codeModel.security = this.securityProcessor.process(this.input);
    let priority = 0;
    for (const { key: name, value: parameter } of this.resolveDictionary(this.input.components?.parameters)) {
      if (parameter["x-ms-parameter-location"] !== "method") {
        if (parameter["x-ms-priority"] === undefined) {
          parameter["x-ms-priority"] = priority++;
        }
      }
    }

    if (this.input.paths) {
      for (const { operation, method, path, pathItem } of this.inputOperations) {
        this.processOperation(operation, method, path, pathItem);
      }

      for (const group of this.codeModel.operationGroups) {
        for (const operation of group.operations) {
          const nl = operation.language.default.paging;
          if (nl && nl.member) {
            // find the member in the group
            const it = group.operations.find((each) => each.language.default.name === nl.member);
            operation.language.default.paging.nextLinkOperation = it;
          }
        }
      }
    }
    if (this.input.components) {
      for (const { key: name, value: header } of this.resolveDictionary(this.input.components.headers)) {
        // TODO Figure out if needed
      }

      for (const { key: name, value: request } of this.resolveDictionary(this.input.components.requestBodies)) {
        // TODO Figure out if needed
      }
      for (const { key: name, value: response } of this.resolveDictionary(this.input.components.responses)) {
        // TODO Figure out if needed
      }
      for (const { key: name, value: schema } of this.resolveDictionary(this.input.components.schemas)) {
        // we don't process binary schemas
        if (this.interpret.isBinarySchema(schema)) {
          continue;
        }

        // if this schema is an empty object with no heirarchy, skip it.
        if (this.interpret.isEmptyObject(schema)) {
          continue;
        }
        this.processSchema(name, schema);
      }
    }

    // Propagate schema usage information to other object schemas.
    // This must occur after all schemas have been visited to ensure
    // nothing gets missed (like discriminator schemas).
    this.codeModel.schemas.objects?.forEach((o) => this.propagateSchemaUsage(o));

    return this.codeModel;
  }

  private propagateSchemaUsage(schema: Schema): void {
    const processedSchemas = new Set<Schema>();

    const innerApplySchemaUsage = (schema: Schema, schemaUsage: SchemaUsage) => {
      this.trackSchemaUsage(schema, schemaUsage);
      innerPropagateSchemaUsage(schema, schemaUsage);
    };

    const innerPropagateSchemaUsage = (schema: Schema, schemaUsage: SchemaUsage) => {
      if (processedSchemas.has(schema)) {
        return;
      }

      processedSchemas.add(schema);
      if (schema instanceof ObjectSchema) {
        if (schemaUsage.usage || schemaUsage.serializationFormats) {
          schema.properties?.forEach((p) => innerApplySchemaUsage(p.schema, schemaUsage));

          schema.parents?.all?.forEach((p) => innerApplySchemaUsage(p, schemaUsage));
          schema.parents?.immediate?.forEach((p) => innerApplySchemaUsage(p, schemaUsage));

          schema.children?.all?.forEach((c) => innerApplySchemaUsage(c, schemaUsage));
          schema.children?.immediate?.forEach((c) => innerApplySchemaUsage(c, schemaUsage));

          items(schema.discriminator?.all).forEach(({ key: k, value: d }) => {
            innerApplySchemaUsage(d, schemaUsage);
          });
          values(schema.discriminator?.immediate).forEach((d) => {
            innerApplySchemaUsage(d, schemaUsage);
          });
        }
      } else if (schema instanceof DictionarySchema) {
        innerApplySchemaUsage(schema.elementType, schemaUsage);
      } else if (schema instanceof ArraySchema) {
        innerApplySchemaUsage(schema.elementType, schemaUsage);
      }
    };

    // Propagate the usage of the initial schema itself
    innerPropagateSchemaUsage(schema, schema as SchemaUsage);
  }

  private trackSchemaUsage(schema: Schema, schemaUsage: SchemaUsage): void {
    if (schema instanceof ObjectSchema) {
      if (schemaUsage.usage) {
        pushDistinct((schema.usage = schema.usage || []), ...schemaUsage.usage);
      }
      if (schemaUsage.serializationFormats) {
        pushDistinct(
          (schema.serializationFormats = schema.serializationFormats || []),
          ...schemaUsage.serializationFormats,
        );
      }
    } else if (schema instanceof DictionarySchema) {
      this.trackSchemaUsage(schema.elementType, schemaUsage);
    } else if (schema instanceof ArraySchema) {
      this.trackSchemaUsage(schema.elementType, schemaUsage);
    }
  }
}
