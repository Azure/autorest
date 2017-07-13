namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class PropertyRef : Expression0
    {
        public Expression0 Left { get; }

        public ObjectName Right { get; }

        public PropertyRef(Expression0 left, ObjectName right)
        {
            Left = left;
            Right = right;
        }

        public override string ToString()
            => $"{Left.ToString()}->{Right.PhpName}";
    }
}
