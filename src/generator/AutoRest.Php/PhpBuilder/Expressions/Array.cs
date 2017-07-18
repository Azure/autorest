using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Array : Expression0
    {
        public IEnumerable<ArrayItem> Items { get; }

        private Array(IEnumerable<ArrayItem> items)
        {
            Items = items;
        }

        public static Array Create(IEnumerable<ArrayItem> items)
            => new Array(items);

        public static Array Create(params ArrayItem[] items)
            => new Array(items);

        public static Array Empty { get; } = Create();

        public override IEnumerable<string> ToCodeText(string indent)
            => Items.ItemsWrap("[", "]", indent);
    }
}
