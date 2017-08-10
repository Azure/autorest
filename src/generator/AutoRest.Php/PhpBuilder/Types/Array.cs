using System;

namespace AutoRest.Php.PhpBuilder.Types
{
    public sealed class Array : IType
    {
        public string AbsoluteName 
            => Items == null ? "array" : Items.AbsoluteName + "[]";

        public string ToParameterPrefix() => "array ";

        public string ToParameterSuffix()
            => string.Empty;

        public IType Items { get; }

        public Array(IType items)
        {
            Items = items;
        }
    }
}
