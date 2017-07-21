using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Functions;
using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Php
{
    public sealed class CodeGeneratorPhp : CodeGenerator
    {
        public override string ImplementationFileExtension => ".php";

        public override string UsageInstructions => string.Empty;

        static string GetMicrosoftRestClass(string name)
            => "Microsoft\\Rest\\" + name;

        static string MicrosoftRestClientStatic { get; }
            = GetMicrosoftRestClass("ClientStatic");

        /// <summary>
        /// Microsoft\Rest\ClientInterface
        /// </summary>
        static string MicrosoftRestClientInterface { get; }
            = GetMicrosoftRestClass("ClientInterface");

        /// <summary>
        /// Microsoft\Rest\OperationInterface
        /// </summary>
        static string MicrosoftRestOperationInterface { get; }
            = GetMicrosoftRestClass("OperationInterface");

        /// <summary>
        /// /**
        ///  * @var Microsoft\Rest\Client
        ///  */
        /// private $_client
        /// </summary>
        static PhpBuilder.Property Client { get; }
            = PHP.Property(new ClassName(MicrosoftRestClientInterface), "_client");

        /// <summary>
        /// $this->_client
        /// </summary>
        static Expression0 ThisClient { get; }
            = PHP.This.Arrow(Client);

        const string CreateOperationFromData = "createOperationFromData";

        static IEnumerable<PhpBuilder.Property> CommonProperties { get; }
            = new[] { Client };

        const string CallFunction = "call";

        static IEnumerable<Statement> OperationInfoInit(
            Expression0 property, ConstName const_, Method m)
        {
            // $this->_client->createOperation({...path...}, {...httpMethod...}, {...operation...})
            var operationInfoCreate = ThisClient.Call(
                CreateOperationFromData,
                PHP.String(m.Url),
                PHP.String(m.HttpMethod.ToString().ToLower()),
                PHP.SelfScope(const_));

            // $this->{...operation...} = 
            return PHP.Statements(property.Assign(operationInfoCreate).Statement());
        }

        private sealed class PhpType
        {
            public string Type { get; }

            public string Format { get; }

            public string Items { get; }

            public PhpType(string type, string format = null, string items = null)
            {
                Type = type;
                Format = format;
                Items = items;
            }

            public static PhpType Create(IModelType modelType)
            {
                if (modelType is PrimaryType type)
                {
                    return new PhpType(
                        type.KnownPrimaryType.ToString().ToLower(),
                        type.KnownFormat.ToString().ToLower());
                }
                else
                {
                    return new PhpType(modelType.Name);
                }
            }
        }

        private sealed class PhpFunction
        {
            public Const Const { get; }

            public PhpBuilder.Property Property { get; }

            public IEnumerable<Statement> ConstructorStatements { get; }

            public Function Function { get; }

            private static IEnumerable<ArrayItem> CreateParameter(Core.Model.Parameter p)
            {
                yield return PHP.KeyValue("name", p.SerializedName);
                yield return PHP.KeyValue("in", p.Location.ToString().ToLower());

                var type = p.ModelType;
                var body = CreateTypeBody(type);
                if (type is CompositeType)
                {
                    yield return PHP.KeyValue("schema", body);
                }
                else
                {
                    foreach (var item in body.Items)
                    {
                        yield return item;
                    }
                }
            }

            public PhpFunction(Method m)
            {
                var name = "_" + m.Name + "_operation";

                var parameters = m.Parameters
                    .Select(p => CreateParameter(p))
                    .Select(PHP.Array)
                    .Select(PHP.KeyValue);

                Const = PHP.Const(
                    name,
                    PHP.Array(
                        PHP.KeyValue("operationId", m.SerializedName),
                        PHP.KeyValue("parameters", PHP.Array(parameters))));

                Property = PHP.Property(new ClassName(MicrosoftRestOperationInterface), name);

                var thisProperty = PHP.This.Arrow(Property);

                ConstructorStatements = OperationInfoInit(thisProperty, Const.Name, m);

                var call = PHP.Return(thisProperty.Call(CallFunction, PHP.EmptyArray));

                Function = PHP.Function(
                    name: m.Name,
                    description: m.Description,
                    body: PHP.Statements(call));
            }
        }

        private sealed class PhpFunctionGroup
        {
            public Class Class { get; }

            public PhpBuilder.Property Property { get; }

            public Function Function { get; }

            public Statement Create { get; }

            public PhpFunctionGroup(string @namespace, MethodGroup o)
            {
                var functions = o.Methods.Select(m => new PhpFunction(m));

                var clientParameter = PHP.Parameter(
                    type: PHP.Class(MicrosoftRestClientInterface),
                    name: Client.Name);

                Class = PHP.Class(
                    name: Class.CreateName(@namespace, o.Name),
                    constructor: PHP.Constructor(
                        parameters: PHP.Parameters(
                            PHP.Parameter(
                                type: PHP.Class(MicrosoftRestClientInterface),
                                name: Client.Name)),
                        body: PHP
                            .Statements(ThisClient.Assign(clientParameter.Ref()).Statement())
                            .Concat(functions.SelectMany(f => f.ConstructorStatements))),
                    functions: functions.Select(f => f.Function),
                    properties: CommonProperties.Concat(functions.Select(f => f.Property)),
                    consts: functions.Select(f => f.Const));

                Property = PHP.Property(Class.Name, "_" + o.Name + "_group");

                Create = PHP.This.Arrow(Property).Assign(PHP.New(Class.Name, ThisClient)).Statement();

                Function = PHP.Function(
                    name: $"get{o.Name}",
                    @return: Class.Name,
                    body: PHP.Statements(PHP.Return(PHP.This.Arrow(Property))));
            }
        }

        const string Indent = "    ";

        static ArrayItem TypeItem(string type)
            => PHP.KeyValue("type", type);

        static ArrayItem FormatItem(string format)
            => PHP.KeyValue("format", format);

        static ArrayItem StringTypeItem { get; } = TypeItem("string");

        static ArrayItem IntegerTypeItem { get; } = TypeItem("integer");

        static IEnumerable<ArrayItem> GetPrimitiveType(PrimaryType type)
        {
            switch (type.KnownPrimaryType)
            {
                case KnownPrimaryType.Int:
                    yield return IntegerTypeItem;
                    yield return FormatItem("int32");
                    break;
                case KnownPrimaryType.Long:
                    yield return IntegerTypeItem;
                    yield return FormatItem("int64");
                    break;
                case KnownPrimaryType.Double:
                    yield return TypeItem("number");
                    yield return FormatItem("double");
                    break;
                case KnownPrimaryType.Decimal:
                    yield return TypeItem("number");
                    yield return FormatItem("decimal");
                    break;
                case KnownPrimaryType.String:
                    yield return StringTypeItem;
                    break;
                case KnownPrimaryType.Boolean:
                    yield return TypeItem("boolean");
                    break;
                case KnownPrimaryType.Date:
                    yield return StringTypeItem;
                    yield return FormatItem("date");
                    break;
                case KnownPrimaryType.DateTime:
                    yield return StringTypeItem;
                    yield return FormatItem("date-time");
                    break;
                case KnownPrimaryType.TimeSpan:
                    yield return StringTypeItem;
                    yield return FormatItem("duration");
                    break;
                case KnownPrimaryType.Object:
                    yield return TypeItem("object");
                    break;
                case KnownPrimaryType.Uuid:
                    yield return StringTypeItem;
                    yield return FormatItem("uuid");
                    break;
                case KnownPrimaryType.DateTimeRfc1123:
                    yield return StringTypeItem;
                    yield return FormatItem("date-time-rfc1123");
                    break;
            }
        }

        static ArrayItem ObjectTypeItem { get; } = TypeItem("object");

        static ArrayItem ArrayTypeItem { get; } = TypeItem("array");

        private static Array CreateCompositeTypeBody(CompositeType type)
            => PHP.Array(PHP.KeyValue(
                "properties",
                PHP.Array(type.Properties.Select(CreateProperty))));

        private static Array CreateTypeBody(IModelType type)
            => type is CompositeType compositeType
                ? PHP.Array(PHP.KeyValue("$ref", "#/definitions/" + compositeType.Name))
                : CreateTypeDefBody(type);

        private static Array CreateTypeDefBody(IModelType type)
            => type is CompositeType compositeType
                    ? PHP.Array(PHP.KeyValue(
                        "properties",
                        PHP.Array(
                            compositeType.Properties.Select(CreateProperty))))
                : type is PrimaryType primaryType
                    ? PHP.Array(GetPrimitiveType(primaryType))
                : type is EnumType enumType
                    ? PHP.Array(StringTypeItem, PHP.KeyValue("enum", PHP.EmptyArray))
                : type is DictionaryType dictionaryType
                    ? PHP.Array(
                        ObjectTypeItem,
                        PHP.KeyValue(
                            "additionalProperties",
                            CreateTypeBody(dictionaryType.ValueType)))
                : type is SequenceType sequenceType
                    ? PHP.Array(
                        ArrayTypeItem,
                        PHP.KeyValue(
                            "items",
                            CreateTypeBody(sequenceType.ElementType)))
                : PHP.EmptyArray;

        private static ArrayItem CreateProperty(Core.Model.Property property)
            => PHP.KeyValue(property.SerializedName, CreateTypeBody(property.ModelType));

        private static ArrayItem CreateTypeDef(IModelType type)
            => PHP.KeyValue(type.Name, CreateTypeDefBody(type));

        private const string DefinitionsData = "_DEFINITIONS_DATA";

        private static Statement CreateClient { get; }
            = ThisClient
                .Assign(new ClassName(MicrosoftRestClientStatic).StaticCall(
                    new FunctionName("createFromData"), PHP.SelfScope(DefinitionsData)))
                .Statement();

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(
                codeModel.Namespace, codeModel.ApiVersion.Replace(".", "_"));

            var phpGroups = codeModel.Operations
                .Where(o => o.Name.RawValue != string.Empty)
                .Select(o => new PhpFunctionGroup(@namespace, o));

            var phpFunctions = codeModel.Operations
                .Where(o => o.Name.RawValue == string.Empty)
                .SelectMany(o => o.Methods.Select(m => new PhpFunction(m)));

            var definitions = PHP.Const(
                DefinitionsData,
                PHP.Array(codeModel.ModelTypes.Select(CreateTypeDef)));

            var client = PHP.Class(
                name: Class.CreateName(@namespace, codeModel.Name),
                constructor: PHP.Constructor(
                    body: PHP
                        .Statements(CreateClient)
                        .Concat(phpGroups.Select(g => g.Create))
                        .Concat(phpFunctions.SelectMany(f => f.ConstructorStatements))),
                functions: phpGroups
                    .Select(o => o.Function)
                    .Concat(phpFunctions.Select(f => f.Function)),
                properties: phpGroups
                    .Select(o => o.Property)
                    .Concat(CommonProperties)
                    .Concat(phpFunctions.Select(f => f.Property)),
                consts: PHP
                    .Consts(definitions)
                    .Concat(phpFunctions.Select(f => f.Const)));

            foreach (var class_ in phpGroups
                .Select(o => o.Class)
                .Concat(ImmutableArray.Create(client)))
            {
                await Write(
                    string.Join("\n", class_.ToCodeText(Indent)),
                    class_.Name.FileName,
                    false);
            }
        }
    }
}
