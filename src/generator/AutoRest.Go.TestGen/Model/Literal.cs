// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// Represents a literal of some integral type.
    /// </summary>
    /// <typeparam name="T">The type of integral (int, string DateTime etc).</typeparam>
    public sealed class Literal<T> : Node
    {
        /// <summary>
        /// Gets the value for this literal.
        /// </summary>
        public T Value { get; }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        public override void AddChild(Node child)
        {
            throw new InvalidOperationException("integral types cannot have child nodes");
        }

        /// <summary>
        /// Creates a new IntegralLiteral object.
        /// </summary>
        /// <param name="value">The value of the literal.</param>
        public Literal(T value)
        {
            Value = value;
        }

        public override string ToString()
        {
            return Value.ToString();
        }
    }
}
