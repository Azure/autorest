using System;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Array : Expression0
    {
        public ImmutableList<Expression> Items { get; }

        public Array(ImmutableList<Expression> items)
        {
            Items = items;
        }

        public static Array Empty { get; }
            = new Array(ImmutableList<Expression>.Empty);

        // public override string ToString()
        //    => $"[{Items.ToPhpCode()}]";

        public override IEnumerable<string> ToLines(string indent)
            => Items.ToPhpCode(indent).Select((line, i) 
                => (i.IsFirst ? "[" : string.Empty)
                    + line
                    + (i.IsLast ? "]" : string.Empty));
    }
}
