// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a switch statement.
    /// </summary>
    public sealed class Switch : Node
    {
        /// <summary>
        /// Creates a new Switch object with no condition expression.
        /// </summary>
        public Switch()
        {
            // empty
        }

        /// <summary>
        /// Creates a new Switch object with the specified condition expression.
        /// </summary>
        /// <param name="condition">The condition to be used in the expression.</param>
        public Switch(Node condition)
        {
            if (condition == null)
            {
                throw new ArgumentNullException(nameof(condition));
            }

            AddChild(condition);
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }
    }
}
