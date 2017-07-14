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

        public override string ToString()
            => $"[{Items.ToPhpCode()}]";
    }
}
