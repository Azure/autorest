namespace AutoRest.Php.PhpBuilder.Types
{
    public sealed class Array : IType
    {
        public string AbsoluteName => "array";

        public string ToParameterPrefix() => "array ";
    }
}
