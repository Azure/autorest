// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents an identifier (e.g. type name, function name etc).
    /// </summary>
    public sealed class Identifier : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Gets the name for this identifier.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// Creates a new Identifier object.
        /// </summary>
        /// <param name="name">The name of the identifier.</param>
        public Identifier(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            Name = name;
        }
    }
}
