// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.CodeAnalysis;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public abstract class ManagedCompiler : Compiler
    {
        private readonly List<MetadataReference> _references;
        private readonly List<SyntaxTree> _syntaxTrees;

        protected ManagedCompiler(Language language, IEnumerable<KeyValuePair<string, string>> sources,
            IEnumerable<MetadataReference> references)
            : base(language, sources)
        {
            _references = new List<MetadataReference>(references ?? Enumerable.Empty<MetadataReference>());
            _syntaxTrees = new List<SyntaxTree>();
        }

        protected abstract CodeAnalysis.Compilation CreateCompilation(IEnumerable<SyntaxTree> syntaxTrees,
            OutputKind outputKind, string outputName);

        protected sealed override Task<CompilationResult> InnerCompile(OutputKind outputKind, string outputName,
            CancellationToken cancellationToken)
        {
            var compilation = CreateCompilation(
                Parse(),
                outputKind,
                outputName ?? "tmp" + Guid.NewGuid().ToString("N"));

            var ms = new MemoryStream();
            var emitResult = compilation.Emit(ms, cancellationToken: cancellationToken);

            var compileResult = new CompilationResult {OutputKind = outputKind};

            compileResult.Messages = emitResult.Diagnostics;
            compileResult.Succeeded = emitResult.Success;

            if (emitResult.Success)
            {
                ms.Seek(0, SeekOrigin.Begin);
                compileResult.Output = ms;
            }
            else
            {
                compileResult.Reason = ResultReasons.Compilation.Failed;
                ms.Dispose();
            }

            return Task.FromResult(compileResult);
        }

        public IEnumerable<SyntaxTree> Parse() => ParseSources().Concat(_syntaxTrees);

        protected abstract IEnumerable<SyntaxTree> ParseSources();

        public IList<MetadataReference> References => _references;

        public IList<SyntaxTree> SyntaxTrees => _syntaxTrees;
    }
}