// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating if blocks.
    /// </summary>
    public static class IfBlock
    {
        /// <summary>
        /// Generates an if block with the specified condition and body.
        /// if condition {
        ///   ...body...
        /// }
        /// </summary>
        /// <param name="condition">The conditional of the if statement.</param>
        /// <param name="body">The body to execute if the condition is true.</param>
        /// <returns>The root node of the if block AST.</returns>
        public static Node Generate(Node condition, IReadOnlyList<Node> body)
        {
            if (condition == null)
            {
                throw new ArgumentNullException(nameof(condition));
            }

            if (body == null || body.Count == 0)
            {
                throw new ArgumentException(nameof(body));
            }

            var ifBlock = new If();
            ifBlock.AddChild(condition);

            var openBrace = new OpenDelimiter(BinaryDelimiterType.Brace);
            foreach (var node in body)
            {
                openBrace.AddChild(node);
            }
            openBrace.AddClosingDelimiter();
            ifBlock.AddChild(openBrace);

            return ifBlock;
        }
    }
}
