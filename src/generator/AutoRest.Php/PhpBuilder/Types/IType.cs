namespace AutoRest.Php.PhpBuilder.Types
{
    public interface IType
    {
        string AbsoluteName { get; }

        string ToParameterPrefix();
    }
}
