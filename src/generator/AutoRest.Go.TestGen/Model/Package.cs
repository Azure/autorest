// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a package.
    /// </summary>
    public sealed class Package : Node
    {
        /// <summary>
        /// Gets the package name.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// Creates a new Package object..
        /// </summary>
        /// <param name="name">The name of the package.</param>
        public Package(string name)
        {
            if (string.IsNullOrWhiteSpace(name))
            {
                throw new ArgumentException(nameof(name));
            }

            // TODO: validate any restrictions on the name?
            Name = name;
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("Package cannot have child nodes.");
        }
    }
}
