using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class FunctionName : Name
    {
        public string PhpName { get; }

        public FunctionName(string original) : base(original)
        {
            PhpName = Original.GetPhpCamelName();
        }

        public IEnumerable<string> GetCall(ImmutableList<Expression> parameters, string indent)
            => parameters
                .ToPhpCode(indent)
                .Select((line, i)
                    => (i.IsFirst ? PhpName + "(" : string.Empty)
                        + line
                        + (i.IsLast ? ")" : string.Empty));
    }
}
