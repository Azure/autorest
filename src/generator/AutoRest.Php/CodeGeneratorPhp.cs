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

        /// <summary>
        /// Microsoft\Rest\Client
        /// </summary>
        static string MicrosoftRestClient { get; }
            = GetMicrosoftRestClass("Client");

        /// <summary>
        /// Microsoft\Rest\Operation
        /// </summary>
        static string MicrosoftRestOperation { get; }
            = GetMicrosoftRestClass("Operation");

        /// <summary>
        /// /**
        ///  * @var Microsoft\Rest\Client
        ///  */
        /// private $_client
        /// </summary>
        static PhpBuilder.Property Client { get; }
            = PHP.Property(MicrosoftRestClient, "_client");

        /// <summary>
        /// $this->_client
        /// </summary>
        static Expression0 ThisClient { get; }
            = PHP.This.Arrow(Client);

        const string CreateOperation = "createOperation";

        static IEnumerable<PhpBuilder.Property> CommonProperties { get; }
            = new[] { Client };

        const string CallFunction = "call";

        static IEnumerable<Statement> OperationInfoInit(
            Expression0 property, ConstName const_, Method m)
        {
            // $this->_client->createOperation({...path...}, {...httpMethod...}, {...operation...})
            var operationInfoCreate = ThisClient.Call(
                CreateOperation,
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
                var phpType = PhpType.Create(p.ModelType);
                yield return PHP.KeyValue("type", phpType.Type);
                if (phpType.Format != "none" && phpType.Format != null)
                {
                    yield return PHP.KeyValue("format", phpType.Format);
                }
                if (phpType.Items != null)
                {
                    yield return PHP.KeyValue("items", phpType.Items);
                }
            }

            public PhpFunction(Method m)
            {
                var name = "_" + m.Name;

                var parameters = m.Parameters
                    .Select(p => CreateParameter(p))
                    .Select(PHP.Array)
                    .Select(PHP.KeyValue);

                Const = PHP.Const(
                    name,
                    PHP.Array(
                        PHP.KeyValue("operationId", m.SerializedName),
                        PHP.KeyValue("parameters", PHP.Array(parameters))));

                Property = PHP.Property(MicrosoftRestOperation, name);

                var thisProperty = PHP.This.Arrow(Property);

                ConstructorStatements = OperationInfoInit(thisProperty, Const.Name, m);

                var call = PHP.Return(thisProperty.Call(CallFunction, PHP.EmptyArray));

                Function = PHP.Function(
                    name: m.Name,
                    description: m.Description,
                    statements: PHP.Statements(call));
            }
        }

        private sealed class PhpFunctionGroup
        {
            public Class Class { get; }

            public PhpBuilder.Property Property { get; }

            public Function Function { get; }

            public PhpFunctionGroup(string @namespace, MethodGroup o)
            {
                var functions = o.Methods.Select(m => new PhpFunction(m));

                var clientParameter = PHP.Parameter(
                    Client.Name,
                    MicrosoftRestClient);

                Class = PHP.Class(
                    name: Class.CreateName(@namespace, o.Name),
                    constructor: PHP.Constructor(
                        parameters: ImmutableArray.Create(
                            PHP.Parameter(
                                Client.Name,
                                MicrosoftRestClient)),
                        statements: PHP
                            .Statements(ThisClient.Assign(clientParameter.Ref()).Statement())
                            .Concat(functions.SelectMany(f => f.ConstructorStatements))),
                    functions: functions.Select(f => f.Function),
                    properties: CommonProperties.Concat(functions.Select(f => f.Property)),
                    consts: functions.Select(f => f.Const));

                Property = PHP.Property(Class.Name, o.Name);

                Function = PHP.Function(
                    name: $"get{o.Name}",
                    @return: Class.Name,
                    statements: PHP.Statements(
                        PHP.Return(PHP.This.Arrow(Property))));
            }
        }

        const string Indent = "    ";

        private static ArrayItem CreateProperty(Core.Model.Property property)
            => PHP.KeyValue(property.SerializedName, PHP.EmptyArray);

        private static ArrayItem CreateType(IModelType type)
        {
            var compositeType = type as CompositeType;
            return PHP.KeyValue(
                type.Name,
                PHP.Array(
                    PHP.KeyValue(
                        "properties",
                        PHP.Array(
                            compositeType.Properties.Select(CreateProperty)))));
        }

        private const string DefinitionsData = "_DEFINITIONS_DATA";

        private static Statement CreateClient { get; }
            = ThisClient
                .Assign(PHP.New(MicrosoftRestClient, PHP.SelfScope(DefinitionsData)))
                .Statement();

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace, codeModel.ApiVersion);
            var operations = codeModel.Operations;
            var phpOperations = operations.Select(o => new PhpFunctionGroup(@namespace, o));
            var definitions = PHP.Const(
                DefinitionsData,
                PHP.Array(codeModel.ModelTypes.Select(CreateType)));
            var client = PHP.Class(
                name: Class.CreateName(@namespace, "Client"),
                constructor: PHP.Constructor(
                    statements: PHP.Statements(CreateClient)),
                functions: phpOperations.Select(o => o.Function),
                properties: phpOperations
                    .Select(o => o.Property)
                    .Concat(CommonProperties),
                consts: PHP.Consts(definitions));
            foreach (var class_ in phpOperations
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
