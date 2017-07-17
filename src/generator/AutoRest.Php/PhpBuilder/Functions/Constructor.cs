using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Constructor : Base
    {
        public Constructor(ImmutableList<Statement> statements): base(statements)
        {
        }

        protected override string PhpName => "__construct";

        public override IEnumerable<string> ToCodeText(string indent)
            => GetBody(indent);
    }
}
