// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a type name (e.g. "foo", "package.Type" etc.).
    /// </summary>
    public sealed class TypeName : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Gets the value for this type name.
        /// </summary>
        public string Value { get; }

        /// <summary>
        /// Creates a new TypeName object.
        /// </summary>
        /// <param name="value">The name of the type.</param>
        public TypeName(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
            {
                throw new ArgumentException(nameof(value));
            }

            // TODO: validate?
            Value = value;
        }
    }
}
