using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class StaticCall : Expression0
    {
        public ClassName Class { get; }

        public FunctionName Function { get; }

        public IEnumerable<Expression> Parameters { get; }

        public StaticCall(
            ClassName @class,
            FunctionName function,
            IEnumerable<Expression> parameters)
        {
            Class = @class;
            Function = function;
            Parameters = parameters;
        }

        public override IEnumerable<string> ToCodeText(string indent)
            => Parameters
                .ItemsWrap("(", ")", indent)
                .InlineWrap(Class.AbsoluteName + "::" + Function.PhpName, string.Empty);
    }
}
