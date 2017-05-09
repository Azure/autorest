// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a default statement (like in a switch statement).
    /// </summary>
    public sealed class Default : Node
    {
        public Default(Node action)
        {
            if (action == null)
            {
                throw new ArgumentNullException(nameof(action));
            }

            base.AddChild(action);
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("Default cannot have child nodes");
        }
    }
}
