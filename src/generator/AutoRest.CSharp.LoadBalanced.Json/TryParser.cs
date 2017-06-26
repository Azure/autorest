namespace AutoRest.CSharp.LoadBalanced.Json
{
    public delegate bool TryParser<in TSource, TTarget>(TSource source, out TTarget target);
}
