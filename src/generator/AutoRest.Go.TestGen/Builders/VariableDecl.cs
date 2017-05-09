// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating variable declarations.
    /// </summary>
    public static class VariableDecl
    {
        /// <summary>
        /// Generates a variable declaration expression with the specified name and type.
        /// E.g. "var foo string".
        /// </summary>
        /// <param name="varName">The name of the variable.</param>
        /// <param name="typeName">The type name of the variable.</param>
        /// <returns>The root node in this declaration AST.</returns>
        public static Node Generate(string varName, string typeName)
        {
            if (string.IsNullOrWhiteSpace(varName))
            {
                throw new ArgumentException(nameof(varName));
            }
            if (string.IsNullOrWhiteSpace(typeName))
            {
                throw new ArgumentException(nameof(typeName));
            }

            var varDef = new VarDef();
            varDef.AddChild(new Identifier(varName));
            varDef.AddChild(new TypeName(typeName));
            return varDef;
        }
    }
}
