namespace AutoRest.TypeScript.SuperAgent.ModelBinder
{
    public interface ITsModelBinder<out T>
    {
        T Bind(CodeModelTs codeModel);
    }
}
