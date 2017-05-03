// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a case statement.
    /// </summary>
    public sealed class Case : Node
    {
        public Case(Node predicate, Node action)
        {
            if (predicate == null)
            {
                throw new ArgumentNullException(nameof(predicate));
            }

            if (action == null)
            {
                throw new ArgumentNullException(nameof(action));
            }

            var colon = new UnaryDelimiter(UnaryDelimiterType.Colon);

            colon.AddChild(predicate);
            colon.AddChild(action);
            base.AddChild(colon);
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("Case cannot have child nodes");
        }
    }
}
