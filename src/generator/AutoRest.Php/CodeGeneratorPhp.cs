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

        static ClassName GetMicrosoftRestClass(string name)
            => new ClassName($"Microsoft\\Rest\\{name}");

        /// <summary>
        /// Microsoft\Rest\Client
        /// </summary>
        static ClassName MicrosoftRestClient { get; }
            = GetMicrosoftRestClass("Client");

        /// <summary>
        /// Microsoft\Rest\Operation
        /// </summary>
        static ClassName MicrosoftRestOperation { get; }
            = GetMicrosoftRestClass("Operation");

        /// <summary>
        /// /**
        ///  * @var Microsoft\Rest\Client
        ///  */
        /// private $_client
        /// </summary>
        static PhpBuilder.Property Client { get; }
            = new PhpBuilder.Property(
                name: "_client", 
                type: MicrosoftRestClient);

        /// <summary>
        /// $this->_client
        /// </summary>
        static Expression0 ClientRef { get; }
            = This.Instance.PropertyRef(Client.Name);

        /// <summary>
        /// $this->_client = new Microsoft\Rest\Client();
        /// </summary>
        static Statement ClientInit { get; }
            = ClientRef
                .Assign(MicrosoftRestClient.New())
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
                yield return ArrayItem.Create("name", p.SerializedName);
                yield return ArrayItem.Create("in", p.Location.ToString().ToLower());
                var phpType = PhpType.Create(p.ModelType);
                yield return ArrayItem.Create("type", phpType.Type);
                if (phpType.Format != "none" && phpType.Format != null)
                {
                    yield return ArrayItem.Create("format", phpType.Format);
                }
                if (phpType.Items != null)
                {
                    yield return ArrayItem.Create("items", phpType.Items);
                }
            }

            public PhpFunction(Method m)
            {
                var name = "_" + m.Name;

                var parameters = m.Parameters
                    .Select(p => CreateParameter(p))
                    .Select(Array.Create)
                    .Select(ArrayItem.Create);

                Const = Const.Create(
                    name,
                    Array.Create(
                        ArrayItem.Create("operationId", m.SerializedName),
                        ArrayItem.Create("parameters", Array.Create(parameters))));

                Property = new PhpBuilder.Property(
                    name: name,
                    type: MicrosoftRestOperation);

                var propertyRef = This
                    .Instance
                    .PropertyRef(Property.Name);

                ConstructorStatements = OperationInfoInit(propertyRef, Const.Name, m);

                var call = propertyRef.Call(CallFunction, Array.Empty).Return();

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

                Class = Class.Create(
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

                Property = new PhpBuilder.Property(o.Name, Class.Name);

                Function = Function.Create(
                    name: $"get{o.Name}",
                    @return: Class.Name,
                    statements: ImmutableArray.Create(
                        This.Instance.PropertyRef(Property.Name).Return()));
            }
        }

        const string Indent = "    ";

        private static ArrayItem CreateProperty(Core.Model.Property property)
            => ArrayItem.Create(property.SerializedName, Array.Empty);

        private static ArrayItem CreateType(IModelType type)
        {
            var compositeType = type as CompositeType;
            return ArrayItem.Create(
                type.Name,
                Array.Create(
                    ArrayItem.Create(
                        "properties",
                        Array.Create(
                            compositeType.Properties.Select(CreateProperty)))));
        }

        private static ConstName DefinitionsData { get; }
            = new ConstName("_DEFINITIONS_DATA");

        private static Statement CreateClient { get; }
            = ClientRef
                .Assign(MicrosoftRestClient.New(DefinitionsData.SelfConstRef()))
                .Statement();

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace, codeModel.ApiVersion);
            var operations = codeModel.Operations;
            var phpOperations = operations.Select(o => new PhpFunctionGroup(@namespace, o));
            var definitions = Const.Create(
                DefinitionsData,
                Array.Create(codeModel.ModelTypes.Select(CreateType)));
            var client = Class.Create(
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
