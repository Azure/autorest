// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating type conversions.
    /// </summary>
    public static class TypeConversion
    {
        /// <summary>
        /// Generates a type conversion sequence for the specified values.
        /// E.g. toTypeName(expression).
        /// </summary>
        /// <param name="expression">The expression to which the type conversion is applied.</param>
        /// <param name="toTypeName">The name of the type.</param>
        /// <returns>The root node in this type conversion AST.</returns>
        public static Node Generate(Node expression, string toTypeName)
        {
            if (expression == null)
            {
                throw new ArgumentNullException(nameof(expression));
            }
            if (string.IsNullOrWhiteSpace(toTypeName))
            {
                throw new ArgumentException(nameof(toTypeName));
            }

            var typeName = new TypeName(toTypeName);
            var openParen = new OpenDelimiter(BinaryDelimiterType.Paren);
            openParen.AddChild(expression);
            openParen.AddClosingDelimiter();
            typeName.AddChild(openParen);
            return typeName;
        }
    }
}
