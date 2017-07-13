using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Functions;
using AutoRest.Php.PhpBuilder.Statements;
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

        static ClassName MicrosoftRestClient { get; } 
            = GetMicrosoftRestClass("Client");

        static ClassName MicrosoftRestOperationsInfo { get; }
            = GetMicrosoftRestClass("Operations\\Info");

        static PhpBuilder.Property Client { get; }
            = new PhpBuilder.Property(
                name: "client", 
                type: MicrosoftRestClient);

        static Expression0 ClientRef { get; }
            = This.Instance.PropertyRef(Client.Name);

        static Statement ClientInit { get; }
            = ClientRef
                .Assign(MicrosoftRestClient.New())
                .Statement();

        static Constructor CommonConstructor { get; }
            = new Constructor(ImmutableList.Create(ClientInit));

        static ImmutableList<PhpBuilder.Property> CommonProperties { get; }
            = ImmutableList.Create(Client);

        static FunctionName CreateFunction { get; }
            = new FunctionName("create");

        static FunctionName CallFunction { get; }
            = new FunctionName("call");

        static Expression0 MicrosoftRestOperationsInfoCreate(string operationId)
            => MicrosoftRestOperationsInfo.StaticCall(
                CreateFunction,
                ImmutableList.Create<Expression>(new StringConst(operationId)));

        private sealed class PhpFunction
        {
            public PhpBuilder.Property Property { get; }

            public Statement Init { get; }

            public Function Function { get; }

            public PhpFunction(Method m)
            {
                Property = new PhpBuilder.Property(
                    name: $"{m.Name}Info",
                    type: MicrosoftRestOperationsInfo,
                    isStatic: true);

                var propertyRef = This
                    .Instance
                    .PropertyRef(Property.Name);

                Init = propertyRef
                    .Assign(MicrosoftRestOperationsInfoCreate(m.SerializedName))
                    .Statement();

                var call = ClientRef
                    .Call(
                        CallFunction,
                        ImmutableList.Create<Expression>(propertyRef, EmptyArray.Instance))
                    .Return();

                Function = new Function(
                    name: m.Name,
                    @return: null,
                    description: m.Description,
                    statements: ImmutableList.Create(call));
            }
        }

        private sealed class PhpFunctionGroup
        {
            public Class Class { get; }

            public PhpBuilder.Property Property { get; }

            public Function Function { get; }

            public PhpFunctionGroup(string @namespace, MethodGroup o)
            {
                var functions = o.Methods.Select(m => new PhpFunction(m)).ToImmutableList();

                Class = new Class(
                    name: Class.CreateName(@namespace, o.Name),
                    constructor: new Constructor(CommonConstructor
                        .Statements
                        .Concat(functions.Select(f => f.Init))
                        .ToImmutableList()),
                    functions: functions.Select(f => f.Function).ToImmutableList(),
                    properties: CommonProperties
                        .Concat(functions.Select(f => f.Property))
                        .ToImmutableList());

                Property = new PhpBuilder.Property(o.Name, Class.Name);

                Function = new Function(
                    name: $"get{o.Name}",
                    @return: Class.Name,
                    statements: ImmutableList.Create(
                        This.Instance.PropertyRef(Property.Name).Return()));
            }
        }

        const string Indent = "    ";

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace, codeModel.ApiVersion);
            var operations = codeModel.Operations;
            var phpOperations = operations.Select(o => new PhpFunctionGroup(@namespace, o));
            var client = new Class(
                name: Class.CreateName(@namespace, "Client"),
                constructor: CommonConstructor,
                functions: phpOperations
                    .Select(o => o.Function)
                    .ToImmutableList(),
                properties: phpOperations
                    .Select(o => o.Property)
                    .Concat(CommonProperties)
                    .ToImmutableList());
            foreach (var class_ in phpOperations
                .Select(o => o.Class)
                .Concat(ImmutableList.Create(client)))
            {
                await Write(string.Join("\n", class_.ToLines(Indent)), class_.Name.FileName, false);
            }
        }
    }
}
