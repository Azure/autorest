using System;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class New : Expression
    {
        public ClassName Type { get; }

        public ImmutableList<Expression> Parameters { get; }

        public New(ClassName type, ImmutableList<Expression> parameters = null)
        {
            Type = type;
            Parameters = parameters.EmptyIfNull();
        }

        public override string ToCodeLine()
            => "new " 
                + Type.AbsoluteName 
                + (Parameters.IsEmpty ? string.Empty : "(" + Parameters.ToPhpCode() + ")");

        public override IEnumerable<string> ToCodeText(string indent)
            => Parameters
                .ItemsWrap("(", ")", indent)
                .InlineWrap("new " + Type.AbsoluteName, string.Empty);
    }
}
