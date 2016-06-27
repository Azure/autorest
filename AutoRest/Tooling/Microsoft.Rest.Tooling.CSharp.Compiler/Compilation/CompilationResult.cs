// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// 

using System.Collections.Generic;
using System.IO;
using Microsoft.CodeAnalysis;

namespace Microsoft.Rest.CSharp.Compiler.Compilation
{
    public struct CompilationResult
    {
        public bool Succeeded;

        public string Reason;

        public IEnumerable<Diagnostic> Messages;

        public MemoryStream Output;

        public OutputKind OutputKind;
    }
}