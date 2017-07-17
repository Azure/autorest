namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class This : Expression0
    {
        public override string ToCodeLine()
            => "$this";

        public static This Instance { get; }
            = new This();

        private This()
        {
        }
    }
}
