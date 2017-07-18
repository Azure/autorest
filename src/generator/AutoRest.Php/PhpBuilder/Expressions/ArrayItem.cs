namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class ArrayItem : ICodeLine
    {
        public Expression Value { get; }

        public StringConst Key { get; }

        public ArrayItem(Expression value, StringConst key = null)
        {
            Value = value;
            Key = key;
        }

        public string ToCodeLine()
            => (Key == null).Then(Key.ToCodeLine() + " => ") + Value.ToCodeLine();
    }
}
