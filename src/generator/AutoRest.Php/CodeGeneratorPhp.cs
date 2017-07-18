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
        static Expression0 ClientRef { get; }
            = PHP.This.Arrow(Client);

        /// <summary>
        /// $this->_client = new Microsoft\Rest\Client();
        /// </summary>
        static Statement ClientInit { get; }
            = ClientRef
                .Assign(PHP.New(MicrosoftRestClient))
                .Statement();

        static FunctionName CreateOperationFunction { get; }
            = new FunctionName("createOperation");

        static Constructor CommonConstructor { get; }
            = Constructor.Create(statements: ImmutableArray.Create(ClientInit));

        static ImmutableArray<PhpBuilder.Property> CommonProperties { get; }
            = ImmutableArray.Create(Client);

        static FunctionName CallFunction { get; }
            = new FunctionName("call");

        static ImmutableList<Statement> OperationInfoInit(
            Expression0 propertyRef, ConstName const_, Method m)
        {
            // $this->_client->createOperation({...path...}, {...httpMethod...}, {...operation...})
            var operationInfoCreate = ClientRef.Call(
                CreateOperationFunction,
                ImmutableList.Create<Expression>(
                    new StringConst(m.Url),
                    new StringConst(m.HttpMethod.ToString().ToLower()),
                    const_.SelfConstRef()));

            // $this->{...operation...} = 
            return ImmutableList.Create(propertyRef.Assign(operationInfoCreate).Statement());
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

            public ImmutableList<Statement> ConstructorStatements { get; }

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

                Const = Const.Create(
                    name,
                    PHP.Array(
                        PHP.KeyValue("operationId", m.SerializedName),
                        PHP.KeyValue("parameters", PHP.Array(parameters))));

                Property = new PhpBuilder.Property(
                    name: name,
                    type: MicrosoftRestOperation);

                var propertyRef = PHP.This.Arrow(Property);

                ConstructorStatements = OperationInfoInit(propertyRef, Const.Name, m);

                var call = propertyRef.Call(CallFunction, PHP.EmptyArray).Return();

                Function = Function.Create(
                    name: m.Name,
                    description: m.Description,
                    statements: ImmutableArray.Create(call));
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

                var clientParameter = PhpBuilder.Functions.Parameter.Create(
                    Client.Name,
                    MicrosoftRestClient);

                Class = PHP.Class(
                    name: Class.CreateName(@namespace, o.Name),
                    constructor: Constructor.Create(
                        parameters: ImmutableArray.Create(
                            PhpBuilder.Functions.Parameter.Create(
                                Client.Name,
                                MicrosoftRestClient)),
                        statements: ImmutableArray
                            .Create(ClientRef.Assign(clientParameter.Ref()).Statement())
                            .Concat(functions.SelectMany(f => f.ConstructorStatements))),
                    functions: functions.Select(f => f.Function),
                    properties: CommonProperties.Concat(functions.Select(f => f.Property)),
                    consts: functions.Select(f => f.Const));

                Property = PHP.Property(Class.Name, o.Name);

                Function = Function.Create(
                    name: $"get{o.Name}",
                    @return: Class.Name,
                    statements: ImmutableArray.Create(
                        PHP.This.Arrow(Property).Return()));
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

        private static ConstName DefinitionsData { get; }
            = new ConstName("_DEFINITIONS_DATA");

        private static Statement CreateClient { get; }
            = ClientRef
                .Assign(PHP.New(MicrosoftRestClient, DefinitionsData.SelfConstRef()))
                .Statement();

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace, codeModel.ApiVersion);
            var operations = codeModel.Operations;
            var phpOperations = operations.Select(o => new PhpFunctionGroup(@namespace, o));
            var definitions = Const.Create(
                DefinitionsData,
                PHP.Array(codeModel.ModelTypes.Select(CreateType)));
            var client = PHP.Class(
                name: Class.CreateName(@namespace, "Client"),
                constructor: Constructor.Create(
                    statements: ImmutableArray.Create(CreateClient)),
                functions: phpOperations.Select(o => o.Function),
                properties: phpOperations
                    .Select(o => o.Property)
                    .Concat(CommonProperties),
                consts: ImmutableArray.Create(definitions));
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
