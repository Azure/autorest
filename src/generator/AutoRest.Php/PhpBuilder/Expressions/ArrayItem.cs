using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class ArrayItem : ICodeText
    {
        public StringConst Key { get; }

        public Expression Value { get; }

        private ArrayItem(StringConst key, Expression value)
        {
            Key = key;
            Value = value;
        }

        public static ArrayItem Create(StringConst key, Expression value)
            => new ArrayItem(key, value);

        public static ArrayItem Create(Expression value)
            => new ArrayItem(null, value);

        public static ArrayItem Create(string key, Expression value)
            => Create(new StringConst(key), value);

        public static ArrayItem Create(string key, string value)
            => Create(key, new StringConst(value));

        public IEnumerable<string> ToCodeText(string indent)
        {
            var lines = Value.ToCodeText(indent);
            return Key == null ? lines : Key.ToCodeText(indent).BinaryOperation(" => ", lines);
        }
    }
}
