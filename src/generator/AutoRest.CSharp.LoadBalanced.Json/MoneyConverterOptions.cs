using System;

namespace AutoRest.CSharp.LoadBalanced.Json
{
    [Flags]
    public enum MoneyConverterOptions
    {
        None = 0,
        SendAsText = 1,
        IsNullable = 2
    }
}