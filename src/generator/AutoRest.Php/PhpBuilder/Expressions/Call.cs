using System;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Call : Expression0
    {
        public Expression0 Left { get; }

        public FunctionName Function { get; }

        public IEnumerable<Expression> Parameters { get; }

        public Call(
            Expression0 left,
            FunctionName function,
            IEnumerable<Expression> parameters = null)
        {
            Left = left;
            Function = function;
            Parameters = parameters.EmptyIfNull();
        }

        public override IEnumerable<string> ToCodeText(string indent)
            => Left.ToCodeText(indent).BinaryOperation(
                "->" + Function.PhpName,
                Parameters.ItemsWrap("(", ")", indent));
    }
}
