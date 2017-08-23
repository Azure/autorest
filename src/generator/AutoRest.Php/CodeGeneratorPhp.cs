using AutoRest.Core;
using AutoRest.Core.Model;
using AutoRest.Php.PhpBuilder;
using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Functions;
using AutoRest.Php.PhpBuilder.Statements;
using AutoRest.Php.PhpBuilder.Types;
using AutoRest.Php.SwaggerBuilder;
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

        static string MicrosoftRestRunTimeStatic { get; }
            = GetMicrosoftRestClass("RunTimeStatic");

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

        static PhpBuilder.Functions.Parameter ClientParameter { get; }
            = PHP.Parameter(
                type: PHP.Class(MicrosoftRestClientInterface),
                name: new ObjectName("_client"));

        static Expression0 ClientParameterRef { get; }
            = ClientParameter.Ref();

        static IEnumerable<PhpBuilder.Functions.Parameter> GroupConstructorParameters { get; }
            = PHP.Parameters(ClientParameter);

        const string CreateOperation = "createOperation";

        const string CallFunction = "call";

        static IEnumerable<Statement> OperationInfoInit(
            Expression0 property, Method m)
        {
            // $_client->createOperation({...operationId...})
            var operationInfoCreate = ClientParameterRef.Call(
                CreateOperation,
                PHP.StringConst(m.SerializedName));

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

        private sealed class PhpOperation
        {
            public PhpBuilder.Property Property { get; }

            public IEnumerable<Statement> ConstructorStatements { get; }

            public Function Function { get; }

            public PhpOperation(Method m)
            {
                var name = "_" + m.Name + "_operation";

                Property = PHP.Property(new ClassName(MicrosoftRestOperationInterface), name);

                var thisProperty = PHP.This.Arrow(Property);

                ConstructorStatements = OperationInfoInit(thisProperty, m);

                var parameters = m.Parameters
                    .Where(p => !p.IsConstant 
                        && !p.IsApiVersion()
                        && p.SerializedName != "subscriptionId");

                var call = PHP.Return(thisProperty.Call(
                    CallFunction,
                    PHP.CreateArray(parameters.Select(p => PHP.KeyValue(
                        p.SerializedName,
                        new ObjectName(p.SerializedName).Ref())))));

                Function = PHP.Function(
                    name: m.Name,
                    description: m.Description,
                    @return: m.ReturnType.Body == null ? null : SchemaObject.Create(m.ReturnType.Body).ToPhpType(),
                    parameters: parameters.Select(p => {
                        var phpType = SchemaObject.Create(p.ModelType).ToPhpType();
                        return PHP.Parameter(
                            p.IsRequired ? phpType : new Nullable(phpType),
                            new ObjectName(p.SerializedName));
                    }),
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
                var functions = o.Methods.Select(m => new PhpOperation(m));

                Class = PHP.Class(
                    name: Class.CreateName(@namespace, o.Name),
                    constructor: PHP.Constructor(
                        parameters: GroupConstructorParameters,
                        body: functions.SelectMany(f => f.ConstructorStatements)),
                    functions: functions.Select(f => f.Function),
                    properties: functions.Select(f => f.Property));

                Property = PHP.Property(Class.Name, "_" + o.Name + "_group");

                Create = PHP
                    .This
                    .Arrow(Property)
                    .Assign(PHP.New(Class.Name, ClientParameterRef))
                    .Statement();

                Function = PHP.Function(
                    name: $"get{o.Name}",
                    @return: Class,
                    body: PHP.Statements(PHP.Return(PHP.This.Arrow(Property))));
            }
        }

        const string Indent = "    ";

        private const string SwaggerObjectData = "_SWAGGER_OBJECT_DATA";

        public static PhpBuilder.Functions.Parameter RunTimeParameter { get; }
            = PHP.Parameter(
                PHP.Class(GetMicrosoftRestClass("RunTimeInterface")),
                new ObjectName("_runTime"));

        private static PhpBuilder.Functions.Parameter SubscriptionId { get; }
            = PHP.Parameter(PHP.String, new ObjectName("subscriptionId"));

        private static Statement CreateClient { get; }
            = ClientParameterRef
                .Assign(RunTimeParameter
                    .Ref()
                    .Call(
                        "createClientFromData",
                        PHP.SelfScope(SwaggerObjectData),
                        PHP.CreateArray(
                            PHP.KeyValue("subscriptionId", 
                            SubscriptionId.Ref()))))
                .Statement();

        public static IEnumerable<PhpBuilder.Functions.Parameter> ClientConstructorParameters { get; }
            = PHP.Parameters(RunTimeParameter, SubscriptionId);

        public override async Task Generate(CodeModel codeModel)
        {
            var @namespace = Class.CreateName(codeModel.Namespace);

            var phpGroups = codeModel.Operations
                .Where(o => o.Name.RawValue != string.Empty)
                .Select(o => new PhpFunctionGroup(@namespace, o));

            var phpFunctions = codeModel.Operations
                .Where(o => o.Name.RawValue == string.Empty)
                .SelectMany(o => o.Methods.Select(m => new PhpOperation(m)));

            var swaggerObjectData = PHP.Const(
                SwaggerObjectData,
                PHP.FromJson(SwaggerObject.Create(codeModel)));

            var client = PHP.Class(
                name: Class.CreateName(@namespace, codeModel.Name),
                constructor: PHP.Constructor(
                    parameters: ClientConstructorParameters,
                    body: PHP
                        .Statements(CreateClient)
                        .Concat(phpGroups.Select(g => g.Create))
                        .Concat(phpFunctions.SelectMany(f => f.ConstructorStatements))),
                functions: phpGroups
                    .Select(o => o.Function)
                    .Concat(phpFunctions.Select(f => f.Function)),
                properties: phpGroups
                    .Select(o => o.Property)
                    .Concat(phpFunctions.Select(f => f.Property)),
                consts: PHP.Consts(swaggerObjectData));

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
