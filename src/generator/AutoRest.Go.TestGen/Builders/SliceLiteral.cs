// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Generates slice literals.
    /// </summary>
    public static class SliceLiteral
    {
        /// <summary>
        /// Generates a slice literal of the specified type name and optional values.
        /// </summary>
        /// <param name="typeName">The fully qualified slice type name.</param>
        /// <param name="values">Optional slice values.  Pass null to omit values.</param>
        /// <returns>The root node in this slice literal AST.</returns>
        public static Node Generate(string typeName, IEnumerable<Node> values)
        {
            if (string.IsNullOrWhiteSpace(typeName))
            {
                throw new ArgumentException(nameof(typeName));
            }

            if (values != null && !values.Any())
            {
                throw new ArgumentException("pass null for no slice elements");
            }

            var openBracket = new OpenDelimiter(BinaryDelimiterType.Bracket);
            var closeBracket = openBracket.AddClosingDelimiter();

            var id = new Identifier(typeName);
            closeBracket.AddChild(id);

            var openBrace = new OpenDelimiter(BinaryDelimiterType.Brace);

            if (values != null)
            {
                var seq = DelimitedSequence.Generate(UnaryDelimiterType.Comma, values.ToList());
                openBrace.AddChild(seq);
            }

            openBrace.AddClosingDelimiter();
            id.AddChild(openBrace);

            return openBracket;
        }
    }
}
