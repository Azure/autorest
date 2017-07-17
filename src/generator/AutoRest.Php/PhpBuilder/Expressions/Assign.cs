using System;
using System.Collections.Generic;

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

        public override string ToCodeLine()
            => Left.ToCodeLine() + " = " + Right.ToCodeLine();
    }
}
