namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class New : Expression
    {
        public ClassName Type { get; }

        public New(ClassName type)
        {
            Type = type;
        }

        public override string ToString()
            => $"new {Type.AbsoluteName}";
    }
}
