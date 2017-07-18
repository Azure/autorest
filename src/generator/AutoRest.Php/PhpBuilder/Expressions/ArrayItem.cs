using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class ArrayItem : ICodeText
    {
        public StringConst Key { get; }

        public Expression Value { get; }

        public ArrayItem(StringConst key, Expression value)
        {
            Key = key;
            Value = value;
        }

        public IEnumerable<string> ToCodeText(string indent)
        {
            var lines = Value.ToCodeText(indent);
            return Key == null ? lines : Key.ToCodeText(indent).BinaryOperation(" => ", lines);
        }
    }
}
