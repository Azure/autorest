using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class FunctionName : Name
    {
        public string PhpName { get; }

        public FunctionName(string original) : base(original)
        {
            PhpName = Original.GetPhpCamelName();
        }

        public string GetCall(IEnumerable<Expression> parameters)
            => PhpName + "(" + parameters.ToPhpCode() + ")";
    }
}
