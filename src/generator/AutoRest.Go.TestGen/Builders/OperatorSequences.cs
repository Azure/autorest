// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.

using AutoRest.Go.TestGen.Model;

namespace AutoRest.Go.TestGen.Builders
{
    /// <summary>
    /// Generates a sequence for binary operators.
    /// </summary>
    public static class BinaryOpSequence
    {
        /// <summary>
        /// Generates a binary operator of the specified type with the specified nodes.
        /// </summary>
        /// <param name="opType">The type of binary operator.</param>
        /// <param name="lhs">The node to appear on the left side of the operator.</param>
        /// <param name="rhs">The node to appear on the right side of the operator.</param>
        /// <returns>The root node of this AST.</returns>
        public static Node Generate(BinaryOperatorType opType, Node lhs, Node rhs)
        {
            var binaryOp = new BinaryOperator(opType);
            binaryOp.AddChild(lhs);
            binaryOp.AddChild(rhs);
            return binaryOp;
        }
    }

    /// <summary>
    /// Generates a sequence for unary operators.
    /// </summary>
    public static class UnaryOpSequence
    {
        /// <summary>
        /// Generates a unary operator of the specified type with the specified node.
        /// </summary>
        /// <param name="opType">The type of unary operator.</param>
        /// <param name="node">The child node.</param>
        /// <returns>The root node of this AST.</returns>
        public static Node Generate(UnaryOperatorType opType, Node node)
        {
            var unaryOp = new UnaryOperator(opType);
            unaryOp.AddChild(node);
            return unaryOp;
        }
    }
}
