// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating for blocks.
    /// </summary>
    public static class ForBlock
    {
        /// <summary>
        /// Generates a for block with the specified loop conditions and body.
        /// </summary>
        /// <param name="init">The optional init statement.</param>
        /// <param name="condition">The optional condition statement.</param>
        /// <param name="post">The optional post statement.</param>
        /// <param name="body">The body of the for loop.</param>
        /// <returns>The root node of the for block AST.</returns>
        public static Node Generate(Node init, Node condition, Node post, IReadOnlyList<Node> body)
        {
            if (init != null || condition != null || post != null)
            {
                throw new NotImplementedException("init, condition and post are NYI");
            }

            if (body == null || body.Count == 0)
            {
                throw new ArgumentException(nameof(body));
            }

            var forBlock = new For();

            var openBrace = new OpenDelimiter(BinaryDelimiterType.Brace);
            foreach (var node in body)
            {
                openBrace.AddChild(node);
            }
            openBrace.AddClosingDelimiter();
            forBlock.AddChild(openBrace);

            return forBlock;
        }
    }
}
