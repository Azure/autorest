// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Core.Utilities;
using AutoRest.Go.Model;
using AutoRest.Go.TestGen.Builders;
using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace AutoRest.Go.TestGen
{
    /// <summary>
    /// Transforms SampleModel objects into Go code.
    /// </summary>
    public static class TestGenGoRpc
    {
        private static string DispatchFuncName = "Dispatch";
        private static string RawResponseTypeName = "testrt.RawResponse";
        private static string ToRawResponseFuncName = "testrt.ToRawResponse";
        private static string LoggerVarName = "logger";

        /// <summary>
        /// Generates test case code for the specified code model.
        /// </summary>
        /// <param name="cmg">The code model for which to create code.</param>
        /// <returns>Root node of the AST.</returns>
        public static Node GenerateTests(CodeModelGo cmg)
        {
            var file = new File();

            var packageName = $"{cmg.Namespace}tests";
            file.AddChild(new Comment($"Package {packageName} contains test functions for package {cmg.Namespace}."));
            file.AddChild(new Package(packageName));
            var imports = GetImports(cmg);
            file.AddChild(imports);
            file.AddChild(new Terminal());

            TestFunctionRpc.TypeAddedEvent = (Core.Model.IModelType modelType) =>
            {
                if (modelType is PrimaryTypeGo)
                {
                    var ptg = modelType as PrimaryTypeGo;
                    if (!string.IsNullOrWhiteSpace(ptg.Import))
                    {
                        var imp = new ImportEntry(ptg.Import);
                        if (!imports.Contains(imp))
                        {
                            imports.AddChild(imp);
                        }
                    }
                }
            };

            file.AddChild(VariableDecl.Generate(LoggerVarName, "*log.Logger"));
            file.AddChild(new Terminal());

            var rpcTypeName = cmg.Name;
            var suiteDef = GetServerReceiver(rpcTypeName);

            file.AddChild(new Comment($"{suiteDef.Item2} is used to dispatch functions calls via JSON-RPC."));
            file.AddChild(suiteDef.Item1);
            file.AddChild(new Terminal());

            file.AddChild(new Comment("RegisterServer enables RPC."));
            file.AddChild(GetRegisterServer(suiteDef.Item2));
            file.AddChild(new Terminal());

            var goMethods = cmg.Methods.Cast<MethodGo>().OrderBy(mg => mg.SerializedName.ToString());

            foreach (var method in goMethods)
            {
                var testFunc = TestFunctionRpc.Generate(method, rpcTypeName, RawResponseTypeName, ToRawResponseFuncName, LoggerVarName);
                file.AddChild(new Comment($"{testFunc.Item2} is a test function for the matching operation ID."));
                file.AddChild(testFunc.Item1);
                file.AddChild(new Terminal());
            }

            return file;
        }

        private static Import GetImports(CodeModelGo cmg)
        {
            var imports = new Import();
            imports.AddRange(new[] {
                new ImportEntry("encoding/json"),
                new ImportEntry("log"),
                new ImportEntry("net/rpc"),
                new ImportEntry($"github.com/Azure/azure-sdk-for-go/arm/{cmg.Namespace}"),
                new ImportEntry("github.com/jhendrixMSFT/gosdkserver/testrt")
            });

            return imports;
        }

        private static Tuple<Node, string> GetServerReceiver(string typeName)
        {
            // make sure type is exported
            if (!char.IsUpper(typeName[0]))
            {
                typeName = $"{char.ToUpperInvariant(typeName[0])}{typeName.Substring(1)}";
            }

            return new Tuple<Node, string>(StructDefinition.Generate(typeName, null), typeName);
        }

        private static Node GetRegisterServer(string typeName)
        {
            var logParamName = "log";

            var func = FunctionSignature.Generate(null, "RegisterServer", new[]
            {
                new FuncParamSig(logParamName, TypeModifier.ByReference, "log.Logger")
            }, null);
            var funcBody = new OpenDelimiter(BinaryDelimiterType.Brace);

            funcBody.AddChild(BinaryOpSequence.Generate(BinaryOperatorType.Assignment, new Identifier(LoggerVarName), new Identifier(logParamName)));
            funcBody.AddChild(new Terminal());

            funcBody.AddChild(FunctionCall.Generate("rpc.Register", new[]
            {
                new FuncCallParam(StructLiteral.Generate(typeName, null), TypeModifier.ByReference)
            }));

            funcBody.AddClosingDelimiter();
            func.AddChild(funcBody);

            return func;
        }
    }
}
