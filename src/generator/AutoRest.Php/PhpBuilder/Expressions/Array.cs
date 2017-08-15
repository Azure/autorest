using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class Array : Expression0
    {
        public IEnumerable<ArrayItem> Items { get; }

        public Array(IEnumerable<ArrayItem> items)
        {
            Items = items;
        }

        public override IEnumerable<string> ToCodeText(string indent)
            => Items.ItemsWrap("[", "]", indent);
    }
}
