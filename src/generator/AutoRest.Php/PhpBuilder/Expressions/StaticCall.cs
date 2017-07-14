using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class StaticCall : Expression0
    {
        public ClassName Class { get; }

        public FunctionName Function { get; }

        public ImmutableList<Expression> Parameters { get; }

        public StaticCall(
            ClassName @class,
            FunctionName function,
            ImmutableList<Expression> parameters = null)
        {
            Class = @class;
            Function = function;
            Parameters = parameters.EmptyIfNull();
        }

        public override string ToString()
            => $"{Class.AbsoluteName}::{Function.GetCall(Parameters)}";

        public override IEnumerable<string> ToLines(string indent)
            => Function
                .GetCall(Parameters)
                .WithBorders()
                .Select(v => (v.IsFirst ? Class.AbsoluteName + "->" : string.Empty) + v.Value);
    }
}
