namespace AutoRest.Php.PhpBuilder
{
    public sealed class FunctionName : Name
    {
        public string PhpName { get; }

        public FunctionName(string original) : base(original)
        {
            PhpName = Original.GetPhpCamelName();
        }
    }
}
