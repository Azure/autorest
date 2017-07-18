using System;
using System.Collections.Generic;
using System.Collections.Immutable;

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

        public override string ToCodeLine()
            => Class.AbsoluteName + "::" + Function.GetCall(Parameters);

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return ToCodeLine();
        }
    }
}
