using AutoRest.Php.PhpBuilder.Statements;
using AutoRest.Php.PhpBuilder.Types;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Constructor : Base
    {
        public Constructor(
            string description,
            IEnumerable<Parameter> parameters,
            IEnumerable<Statement> body)
            : base(description, parameters, body)
        {
        }

        protected override string PhpName => "__construct";

        public override IType Return => null;

        public override IEnumerable<string> ToCodeText(string indent)
            => GetBody(indent);
    }
}
