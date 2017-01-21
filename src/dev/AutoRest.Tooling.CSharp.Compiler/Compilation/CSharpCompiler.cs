// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public class CSharpCompiler : ManagedCompiler
    {
        private static readonly CSharpParseOptions parseOptions = new CSharpParseOptions(
            LanguageVersion.CSharp6,
            DocumentationMode.Diagnose);

        public CSharpCompiler(IEnumerable<KeyValuePair<string, string>> sources,
            IEnumerable<string> referencesAsFilenames)
            : base(
                Language.CSharp, sources,
                referencesAsFilenames.Select(
                    each => MetadataReference.CreateFromFile(each, MetadataReferenceProperties.Assembly)))
        {
        }

        protected sealed override CodeAnalysis.Compilation CreateCompilation(IEnumerable<SyntaxTree> syntaxTrees,
            OutputKind outputKind, string outputName)
        {
            var compilation = CSharpCompilation.Create(
                outputName,
                syntaxTrees,
                References,
                GetCompilationOptions(outputKind));

            return compilation;
        }

        protected sealed override IEnumerable<SyntaxTree> ParseSources()
        {
            var syntaxTrees =
                from source in Sources
                where !string.IsNullOrWhiteSpace(source.Value)
                // ParseText throws a NullRefEx on empty files
                select CSharpSyntaxTree.ParseText(source.Value, parseOptions, source.Key);

            return syntaxTrees.ToList();
        }

        #region Helpers

        public static CSharpCompilationOptions GetCompilationOptions(OutputKind outputKind)
        {
            switch (outputKind)
            {
                case OutputKind.ConsoleApplication:
                    return new CSharpCompilationOptions(
                        CodeAnalysis.OutputKind.ConsoleApplication,
                        allowUnsafe: false,
                        concurrentBuild: false,
                        optimizationLevel: OptimizationLevel.Debug);

                case OutputKind.DynamicallyLinkedLibrary:
                    return new CSharpCompilationOptions(
                        CodeAnalysis.OutputKind.DynamicallyLinkedLibrary,
                        allowUnsafe: false,
                        concurrentBuild: false,
                        optimizationLevel: OptimizationLevel.Debug);

                default:
                    throw new NotSupportedException();
            }
        }

        #endregion
    }
}