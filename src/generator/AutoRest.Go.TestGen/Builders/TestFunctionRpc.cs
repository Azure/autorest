// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Go.Model;
using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating test functions.
    /// </summary>
    public static class TestFunctionRpc
    {
        private static string ReservedParamsFieldName = "ReservedParams";

        public delegate void TypeAddedDelegate(Core.Model.IModelType modelType);

        /// <summary>
        /// The event that's raised when a type is added to the params marshalling struct definition.
        /// </summary>
        public static TypeAddedDelegate TypeAddedEvent;

        /// <summary>
        /// Generates a test case function for the specified method.
        /// </summary>
        /// <param name="mg">The method for which a test case will be generated.</param>
        /// <param name="rpcTypeName">The type name use for RPC dispatch.</param>
        /// <returns>The root node in this test case function AST.</returns>
        public static Tuple<Node, string> Generate(MethodGo mg, string rpcTypeName, string replyTypeName, string replyConvFuncName, string loggerVarName)
        {
            if (mg == null)
            {
                throw new ArgumentNullException(nameof(mg));
            }

            if (string.IsNullOrWhiteSpace(replyTypeName))
            {
                throw new ArgumentException(nameof(replyTypeName));
            }

            if (string.IsNullOrWhiteSpace(replyConvFuncName))
            {
                throw new ArgumentException(nameof(replyConvFuncName));
            }

            var errorVar = "err";
            var jsonParamVar = "parameters";
            var replyVar = "reply";

            var operationId = mg.SerializedName.ToString();
            if (!char.IsUpper(operationId[0]))
            {
                operationId = $"{char.ToUpperInvariant(operationId[0])}{operationId.Substring(1)}";
            }

            var rpcTypeVar = char.ToLowerInvariant(rpcTypeName[0]).ToString();

            var func = FunctionSignature.Generate(new FuncParamSig(rpcTypeVar, TypeModifier.ByReference, rpcTypeName),
                operationId, new[]
            {
                new FuncParamSig(jsonParamVar, TypeModifier.ByValue, "json.RawMessage"),
                new FuncParamSig(replyVar, TypeModifier.ByReference, replyTypeName)
            }, new[]
            {
                new FuncReturnSig(null, TypeModifier.ByValue, "error")
            });

            var funcBody = new OpenDelimiter(BinaryDelimiterType.Brace);

            // generate a type used to unmarshal the parameters
            string unmarshalVar = null;
            var unmarshalType = GenerateTypeForParamsUnmarshal(mg);
            funcBody.AddChild(unmarshalType.Item1);
            funcBody.AddChild(new Terminal());

            unmarshalVar = unmarshalType.Item2.ToLowerInvariant();

            // do the unmarshaling and return on failure
            funcBody.AddChild(VariableDecl.Generate(unmarshalVar, unmarshalType.Item2));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.DeclareAndAssign, new Identifier(errorVar),
                FunctionCall.Generate("json.Unmarshal", new[]
                {
                new FuncCallParam(new Identifier(jsonParamVar), TypeModifier.ByValue),
                new FuncCallParam(new Identifier(unmarshalVar), TypeModifier.ByReference)
                })));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(ErrorCheck.Generate(errorVar, OnError.ReturnError));
            funcBody.AddChild(new Terminal());

            var authVar = "auth";

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.DeclareAndAssign,
                DelimitedSequence.Generate(UnaryDelimiterType.Comma, new[]
                {
                    new Identifier(authVar),
                    new Identifier(errorVar)
                }),
                FunctionCall.Generate($"{unmarshalVar}.{ReservedParamsFieldName}.Credentials.CreateBearerAuthorizer", null)));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(ErrorCheck.Generate(errorVar, OnError.ReturnError));
            funcBody.AddChild(new Terminal());

            // create the client and call the target function
            var clientVar = "client";

            // check if the client ctor has any parameters
            List<FuncCallParam> clientParams = null;
            if (!string.IsNullOrWhiteSpace(((MethodGroupGo)mg.MethodGroup).GlobalParameters))
            {
                clientParams = new List<FuncCallParam>();
                var globalParams = ((MethodGroupGo)mg.MethodGroup).GlobalParameters.Split(new[] { ',' });

                // each param is the var name followed by the type name, e.g. "subscriptionID string"
                foreach (var globalParam in globalParams)
                {
                    var paramName = globalParam.Substring(0, globalParam.IndexOf(' '));
                    clientParams.Add(new FuncCallParam(new Identifier($"{unmarshalVar}.{paramName.Capitalize()}"), TypeModifier.ByValue));
                }
            }

            funcBody.AddChild(FunctionCall.Generate($"{loggerVarName}.Println", new[]
            {
                new FuncCallParam(new Literal<string>(operationId), TypeModifier.ByValue)
            }));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(FunctionCall.Generate($"{loggerVarName}.Printf", new[]
            {
                new FuncCallParam(new Literal<string>("received %v\\n"), TypeModifier.ByValue),
                new FuncCallParam(new Identifier(unmarshalVar), TypeModifier.ByValue)
            }));
            funcBody.AddChild(new Terminal());

            // the client creation function name prefix is hard-coded in the Go generator
            var clientCtorName = $"{mg.CodeModel.Namespace}.New";
            if (!string.IsNullOrWhiteSpace(mg.MethodGroup.Name))
            {
                clientCtorName = $"{clientCtorName}{((MethodGroupGo)mg.MethodGroup).ClientName}";
            }

            funcBody.AddChild(BinaryOpSequence.Generate(
                BinaryOperatorType.DeclareAndAssign,
                new Identifier(clientVar),
                FunctionCall.Generate(clientCtorName, clientParams)));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.Assignment,
                new Identifier($"{clientVar}.Authorizer"), new Identifier(authVar)));
            funcBody.AddChild(new Terminal());

            var rChanVar = "rChan";
            var eChanVar = "eChan";
            var responseVar = "resp";
            var rawResponseVar = "rawResp";

            var isLro = mg.IsLongRunningOperation() && !mg.IsPageable;

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.DeclareAndAssign,
                DelimitedSequence.Generate(UnaryDelimiterType.Comma, new[]
                {
                    new Identifier(isLro ? rChanVar : responseVar),
                    new Identifier(isLro ? eChanVar : errorVar)
                }),
                FunctionCall.Generate($"{clientVar}.{mg.Name}", GenerateApiCallParams(mg, unmarshalVar))));
            funcBody.AddChild(new Terminal());

            if (isLro)
            {
                funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.Assignment,
                    new Identifier(errorVar), new Identifier($"<-{eChanVar}")));
                funcBody.AddChild(new Terminal());
            }

            funcBody.AddChild(ErrorCheck.Generate(errorVar, OnError.ReturnError));
            funcBody.AddChild(new Terminal());

            if (isLro)
            {
                funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.DeclareAndAssign,
                    new Identifier(responseVar), new Identifier($"<-{rChanVar}")));
                funcBody.AddChild(new Terminal());
            }

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.DeclareAndAssign,
                DelimitedSequence.Generate(UnaryDelimiterType.Comma, new[]
                {
                    new Identifier(rawResponseVar),
                    new Identifier(errorVar)
                }),
                FunctionCall.Generate(replyConvFuncName, new[]
                {
                    new FuncCallParam(new Identifier(mg.HasReturnValue() ? $"{responseVar}.Response" : $"{responseVar}"), TypeModifier.ByReference),
                    new FuncCallParam(mg.HasReturnValue() ? (Node)new Identifier(responseVar) : new Nil(), TypeModifier.ByValue)
                })));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(FunctionCall.Generate($"{loggerVarName}.Printf", new[]
            {
                new FuncCallParam(new Literal<string>("response %v\\n"), TypeModifier.ByValue),
                new FuncCallParam(new Identifier($"*{rawResponseVar}"), TypeModifier.ByValue)
            }));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.Assignment,
                new Identifier($"*{replyVar}"), new Identifier($"*{rawResponseVar}")));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(ReturnStatement.Generate(new[]
            {
                errorVar
            }));

            funcBody.AddClosingDelimiter();
            func.AddChild(funcBody);
            return new Tuple<Node, string>(func, operationId);
        }

        private static Tuple<Node, string> GenerateTypeForParamsUnmarshal(MethodGo mg)
        {
            var typeName = $"{mg.Name}Params";
            var fields = new List<StructFieldDef>();
            fields.Add(new StructFieldDef("SubscriptionID", "string", "json:\"subscriptionId\""));

            if (mg.LocalParameters.Any())
            {
                foreach (var param in mg.LocalParameters)
                {
                    string fieldTypeName = null;
                    if (param.ModelType is PrimaryTypeGo)
                    {
                        fieldTypeName = param.ModelTypeName;
                    }
                    else if (param.ModelType is CompositeTypeGo)
                    {
                        fieldTypeName = $"{mg.CodeModel.Namespace}.{param.ModelTypeName}";
                    }
                    else if (param.ModelType is SequenceTypeGo)
                    {
                        var st = param.ModelType as SequenceTypeGo;
                        if (st.ElementType is PrimaryTypeGo || st.ElementType is EnumTypeGo)
                        {
                            fieldTypeName = $"[]{st.ElementType.Name}";
                        }
                        else
                        {
                            fieldTypeName = $"[]{mg.CodeModel.Namespace}.{st.ElementType.Name}";
                        }
                    }
                    else if (param.ModelType is EnumTypeGo)
                    {
                        // TODO
                        fieldTypeName = $"{mg.CodeModel.Namespace}.{param.ModelTypeName}";
                    }
                    else
                    {
                        throw new NotImplementedException($"support for param type {param.ModelType} NYI");
                    }

                    fields.Add(new StructFieldDef(param.Name.ToString().Capitalize(), fieldTypeName, $"json:\"{param.SerializedName}\""));
                    TypeAddedEvent?.Invoke(param.ModelType);
                }
            }

            fields.Add(new StructFieldDef(ReservedParamsFieldName, "testrt.ReservedParams", "json:\"__reserved\""));
            var structDef = StructDefinition.Generate(typeName, fields);
            return new Tuple<Node, string>(structDef, typeName);
        }

        private static IReadOnlyList<FuncCallParam> GenerateApiCallParams(MethodGo mg, string unmarshalVar)
        {
            // use mg.LocalParameters instead of Parameters so that the 
            // subscription ID and API version params (and possibly others)
            // are omitted as they are part of the client.
            if (!mg.LocalParameters.Any())
                return null;

            var funcCallParams = new List<FuncCallParam>();

            // the go generator places parameters that aren't required at the end
            // TODO: expose this in the generator so we don't have to duplicate the logic
            var paramsList = mg.LocalParameters.OrderBy(p => !p.IsRequired).ToList();
            foreach (var param in paramsList)
            {
                TypeModifier typeMod = TypeModifier.ByReference;
                if (param.IsRequired || param.ModelType.CanBeEmpty())
                {
                    typeMod = TypeModifier.ByValue;
                }

                funcCallParams.Add(new FuncCallParam(new Identifier($"{unmarshalVar}.{param.Name.ToString().Capitalize()}"), typeMod));
            }

            // if this is a long-running operation there will be an optional channel
            // parameter at the end of the parameter list, pass nil for this one.
            if (mg.IsLongRunningOperation())
            {
                funcCallParams.Add(new FuncCallParam(new Nil(), TypeModifier.ByValue));
            }

            return funcCallParams;
        }
    }
}
