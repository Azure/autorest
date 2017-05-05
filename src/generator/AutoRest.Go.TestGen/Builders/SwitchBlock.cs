// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Represents a case statement in a switch-case block.
    /// </summary>
    public struct SwitchCase
    {
        /// <summary>
        /// The predicate.
        /// </summary>
        public Node Predicate;

        /// <summary>
        /// The action to execute if the predicate is true.
        /// </summary>
        public Node Action;

        /// <summary>
        /// Initialiizes SwitchCase with the specified parameters.
        /// </summary>
        /// <param name="predicate">The predicate to evaluate.</param>
        /// <param name="action">The action to execute.</param>
        public SwitchCase(Node predicate, Node action)
        {
            Predicate = predicate;
            Action = action;
        }
    }

    /// <summary>
    /// Used for generating switch-case statements.
    /// </summary>
    public static class SwitchBlock
    {
        /// <summary>
        /// Generates a switch-case block with the specified clauses.
        /// </summary>
        /// <param name="condition">Optional condition expression.</param>
        /// <param name="cases">List of cases, must be at least one.</param>
        /// <param name="defaultAction">Optional default action.</param>
        /// <returns>The root node in this switch block AST.</returns>
        public static Node Generate(Node condition, IReadOnlyList<SwitchCase> cases, Node defaultAction)
        {
            if (cases == null || cases.Count == 0)
            {
                throw new ArgumentException(nameof(cases));
            }

            Switch switchStmt;
            if (condition != null)
            {
                switchStmt = new Switch(condition);
            }
            else
            {
                switchStmt = new Switch();
            }

            var openBrace = new OpenDelimiter(BinaryDelimiterType.Brace);

            foreach (var c in cases)
            {
                openBrace.AddChild(new Case(c.Predicate, c.Action));
                openBrace.AddChild(new Terminal());
            }

            if (defaultAction != null)
            {
                openBrace.AddChild(new Default(defaultAction));
            }

            openBrace.AddClosingDelimiter();
            switchStmt.AddChild(openBrace);
            return switchStmt;
        }
    }
}
