// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a tag on a struct field.
    /// </summary>
    public sealed class Tag : Node
    {
        /// <summary>
        /// Gets the value for this tag.
        /// </summary>
        public string Value { get; }

        /// <summary>
        /// Creates a new Tag object.
        /// </summary>
        /// <param name="value">The value for the tag.</param>
        public Tag(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                throw new ArgumentException(nameof(value));
            }

            Value = value;
        }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("Tag object cannot have child nodes");
        }
    }
}
