using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Call : Expression0
    {
        public Expression0 Left { get; }

        public FunctionName Function { get; }

        public ImmutableList<Expression> Parameters { get; }

        public Call(
            Expression0 left,
            FunctionName function,
            ImmutableList<Expression> parameters = null)
        {
            Left = left;
            Function = function;
            Parameters = parameters.EmptyIfNull();
        }

        public override string ToCodeLine()
            => Left.ToCodeLine() + "->" + Function.GetCall(Parameters);
    }
}
