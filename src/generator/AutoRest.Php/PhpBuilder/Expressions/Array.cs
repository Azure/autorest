using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Array : Expression0
    {
        public ImmutableList<ArrayItem> Items { get; }

        public Array(ImmutableList<ArrayItem> items)
        {
            Items = items;
        }

        public static Array Empty { get; }
            = new Array(ImmutableList<ArrayItem>.Empty);

        public override string ToCodeLine()
            => "[" + Items.ToPhpCode() + "]";

        public override IEnumerable<string> ToCodeText(string indent)
            => Items.ItemsWrap("[", "]", indent);
    }
}
