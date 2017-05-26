using AutoRest.Core.Model;

namespace AutoRest.CSharp.Azure.JsonRpcClient
{
    public static class ParamEx
    {
        public static string GetInfoName(this Parameter p)
            => $"{p.Method.Name}_{p.SerializedName.Value.Replace('-', '_')}_ParamInfo";
    }
}
