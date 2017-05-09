// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// A type of binary delimiter.
    /// </summary>
    public enum BinaryDelimiterType
    {
        /// <summary>
        /// Parenthesis ().
        /// </summary>
        Paren,

        /// <summary>
        /// Curly brace {}.
        /// </summary>
        Brace,

        /// <summary>
        /// Square bracket [].
        /// </summary>
        Bracket,
    }

    /// <summary>
    /// A type of unary delimiter.
    /// </summary>
    public enum UnaryDelimiterType
    {
        /// <summary>
        /// Colon :
        /// </summary>
        Colon,

        /// <summary>
        /// Comma ,
        /// </summary>
        Comma
    }

    /// <summary>
    /// Represents an opening delimiter of some kind.
    /// </summary>
    public sealed class OpenDelimiter : Node
    {
        /// <summary>
        /// Gets the type of delimiter.
        /// </summary>
        public BinaryDelimiterType Type { get; }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Creates a new OpenDelimiter object.
        /// </summary>
        /// <param name="type">The type of binary delimiter.</param>
        public OpenDelimiter(BinaryDelimiterType type)
        {
            Type = type;
        }

        /// <summary>
        /// Adds the matching closing delimiter to the list of children.
        /// </summary>
        public Node AddClosingDelimiter()
        {
            var closeDelim = new CloseDelimiter(Type);
            AddChild(closeDelim);
            return closeDelim;
        }
    }

    /// <summary>
    /// Represents a closing delimiter of some kind.
    /// </summary>
    public sealed class CloseDelimiter : Node
    {
        /// <summary>
        /// Gets the type of delimiter.
        /// </summary>
        public BinaryDelimiterType Type { get; }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Creates a new CloseDelimiter object.
        /// </summary>
        /// <param name="type">The type of binary delimiter.</param>
        public CloseDelimiter(BinaryDelimiterType type)
        {
            Type = type;
        }
    }

    /// <summary>
    /// Represents a sequence delimiter.
    /// </summary>
    public sealed class UnaryDelimiter : Node
    {
        /// <summary>
        /// Gets the type of delimiter.
        /// </summary>
        public UnaryDelimiterType Type { get; }

        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Creates a new UnaryDelimiter object.
        /// </summary>
        /// <param name="type">The type of unary delimiter.</param>
        public UnaryDelimiter(UnaryDelimiterType type)
        {
            Type = type;
        }

        public override void AddChild(Node child)
        {
            if (Children.Count == 2)
            {
                throw new InvalidOperationException("unary delimiter cannot have more than two child nodes");
            }

            base.AddChild(child);
        }

        public override void Visit(INodeVisitor visitor)
        {
            if (Children.Count < 2)
            {
                throw new InvalidOperationException("unary operator must have two children");
            }

            Children[0].Visit(visitor);
            Accept(visitor);
            Children[1].Visit(visitor);
        }
    }
}
