namespace AutoRest.Php.PhpBuilder.Types
{
    public sealed class Nullable : IType
    {
        public IType Type { get; }

        public string AbsoluteName => Type.AbsoluteName + "|null";

        public string ToParameterPrefix()
            => Type.ToParameterPrefix();

        public string ToParameterSuffix()
            => " = null";

        public Nullable(IType type)
        {
            Type = type;
        }
    }
}
