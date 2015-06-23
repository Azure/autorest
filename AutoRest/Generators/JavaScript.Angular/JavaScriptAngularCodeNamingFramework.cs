// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System.Collections.Generic;
using Microsoft.Rest.Generator.ClientModel;
using Microsoft.Rest.Generator.Utilities;

namespace Microsoft.Rest.Generator.JavaScript.Angular
{
    public class JavaScriptAngularCodeNamingFramework : CodeNamingFramework
    {
        /// <summary>
        /// Initializes a new instance of JavaScriptAngularCodeNamingFramework.
        /// </summary>
        public JavaScriptAngularCodeNamingFramework()
        {
            new HashSet<string>
            {
                "abstract", "await",     "boolean",    "break",        "byte",
                "case",     "catch",     "char",       "class",        "const",
                "continue", "debugger",  "default",    "delete",       "do",
                "double",   "else",      "enum",       "export",       "extends",
                "false",    "final",     "finally",    "float",        "for",
                "function", "goto",      "if",         "implements",   "import",
                "in",       "int",       "instanceof", "interface",    "let",
                "long",     "native",    "new",        "null",         "package",
                "private",  "protected", "public",     "return",       "short",
                "static",   "super",     "switch",     "synchronized", "this",
                "throw",    "transient", "true",       "try",          "typeof",
                "var",      "void",       "volatile",  "while",        "with",
                "yield"
            }.ForEach(s => ReservedWords.Add(s));
        }

        protected override IType NormalizeType(IType type)
        {
            // No type normalization required.
            return type;
        }
    }
}