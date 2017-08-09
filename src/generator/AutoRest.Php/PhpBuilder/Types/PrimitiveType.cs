using System;

namespace AutoRest.Php.PhpBuilder.Types
{
    sealed class PrimitiveType : IType
    {
        public string AbsoluteName { get; }

        public PrimitiveType(string absoluteName)
        {
            AbsoluteName = absoluteName;
        }

        public string ToParameterPrefix() => string.Empty;

        public string ToParameterSuffix() => string.Empty;
    }
}
