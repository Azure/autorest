// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using System;

namespace AutoRest.Go.TestGen.Model
{
    /// <summary>
    /// A type of binary operator.
    /// </summary>
    public enum BinaryOperatorType
    {
        /// <summary>
        /// =
        /// </summary>
        Assignment,

        /// <summary>
        /// :=
        /// </summary>
        DeclareAndAssign,

        /// <summary>
        /// !=
        /// </summary>
        NotEqualTo
    }

    /// <summary>
    /// A type of unary operator.
    /// </summary>
    public enum UnaryOperatorType
    {
        /// <summary>
        /// &
        /// </summary>
        Ampersand,

        /// <summary>
        /// *
        /// </summary>
        Star
    }

    /// <summary>
    /// Represents a binary operator (e.g. assignment, addition etc).
    /// </summary>
    public sealed class BinaryOperator : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Gets the type of this operator.
        /// </summary>
        public BinaryOperatorType Type { get; }

        /// <summary>
        /// Creates a new BinaryOperator object.
        /// </summary>
        /// <param name="type"></param>
        public BinaryOperator(BinaryOperatorType type)
        {
            Type = type;
        }

        public override void Visit(INodeVisitor visitor)
        {
            if (Children.Count != 2)
            {
                throw new InvalidOperationException("binary operator must have two children");
            }

            Children[0].Visit(visitor);
            Accept(visitor);
            Children[1].Visit(visitor);
        }
    }

    /// <summary>
    /// Represents a unary operator (e.g. &).
    /// </summary>
    public sealed class UnaryOperator : Node
    {
        public override void Accept(INodeVisitor visitor)
        {
            visitor.Visit(this);
        }

        /// <summary>
        /// Gets the type of this operator.
        /// </summary>
        public UnaryOperatorType Type { get; }

        /// <summary>
        /// Creates a new UnaryOperator object.
        /// </summary>
        /// <param name="type">The type of unary operator.</param>
        public UnaryOperator(UnaryOperatorType type)
        {
            Type = type;
        }

        public override void AddChild(Node child)
        {
            if (Children.Count == 1)
            {
                throw new InvalidOperationException("unary operator can only have one child node");
            }

            base.AddChild(child);
        }
    }
}
