namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class EmptyArray : Expression0
    {
        public override string ToString()
            => "[]";

        public static EmptyArray Instance { get; }
            = new EmptyArray();

        private EmptyArray()
        {
        }
    }
}
