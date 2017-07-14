using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Assign : Expression
    {
        public Expression0 Left { get; }

        public Expression Right { get; }

        public Assign(Expression0 left, Expression right)
        {
            Left = left;
            Right = right;
        }

        public override string ToString()
            => $"{Left.ToString()} = {Right.ToString()}";

        public override IEnumerable<string> ToLines(string indent)
            => Left.BinaryOperation(" = ", Right, indent);
    }
}
