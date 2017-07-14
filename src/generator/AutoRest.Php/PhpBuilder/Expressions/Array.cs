using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

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

        public override string ToString()
            => $"[{Items.ToPhpCode()}]";

        public override IEnumerable<string> ToLines(string indent)
        {
            if (Items.Count == 0)
            {
                yield return "[]";
            }
            else
            {
                var lines = Items.SelectMany(i => i.ToLines(indent)).ToImmutableList();
                if (lines.Count == 1)
                {
                    yield return $"[{lines[0]}]";
                }
                else
                {
                    yield return "[";
                    foreach (var line in lines)
                    {
                        yield return $"{indent}{line}";
                    }
                    yield return "]";
                }
            }
        }
    }
}
