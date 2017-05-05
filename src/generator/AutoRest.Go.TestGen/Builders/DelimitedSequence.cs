// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Used for generating sequences.
    /// </summary>
    public sealed class DelimitedSequence
    {
        /// <summary>
        /// Generates a sequence of nodes separated by the specified unary delimiter.
        /// </summary>
        /// <param name="delimiter">The type of unary delimiter.</param>
        /// <param name="sequence">The sequence of nodes to be delimited.</param>
        /// <param name="addTrailing">Include a trailing delimiter, false by default.</param>
        /// <returns>The root node of this sequence AST.</returns>
        public static Node Generate(UnaryDelimiterType delimiter, IReadOnlyList<Node> sequence, bool addTrailing = false)
        {
            if (sequence.Count == 0)
            {
                throw new ArgumentException("sequence is empty");
            }

            // build a comma separated list of params
            Node paramSeq = null;

            // create an array of dilimiter nodes if there is more than
            // one item in the sequence and build a tree with them.
            UnaryDelimiter[] delimiters = null;
            if (sequence.Count > 1 || addTrailing)
            {
                var count = addTrailing ? sequence.Count : sequence.Count - 1;
                delimiters = new UnaryDelimiter[count];
                for (int i = 0; i < count; ++i)
                {
                    delimiters[i] = new UnaryDelimiter(delimiter);
                }
                paramSeq = delimiters[0];
            }

            for (int i = 0, j = 0; i < sequence.Count; ++i)
            {
                var seq = sequence[i];

                if (delimiters != null)
                {
                    // if the current delimiter has all of
                    // its children move to the next one
                    if (delimiters[j].Children.Count == 2)
                    {
                        ++j;
                    }

                    delimiters[j].AddChild(seq);

                    // if there's one or more delimiters left add
                    // the next one as a child of the current one
                    if (j + 1 < delimiters.Length)
                    {
                        delimiters[j].AddChild(delimiters[j + 1]);
                    }
                }
                else
                {
                    // only one param and no trailing delimiter
                    paramSeq = seq;
                }
            }

            if (addTrailing)
            {
                delimiters[delimiters.Length - 1].AddChild(new Terminal());
            }

            return paramSeq;
        }
    }
}
