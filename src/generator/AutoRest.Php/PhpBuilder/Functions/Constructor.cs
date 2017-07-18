using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Constructor : Base
    {
        private Constructor(
            IEnumerable<Parameter> parameters,
            string description,
            IEnumerable<Statement> statements)
            : base(parameters, description, statements)
        {
        }

        protected override string PhpName => "__construct";

        public override ClassName Return => null;

        public override IEnumerable<string> ToCodeText(string indent)
            => GetBody(indent);

        public static Constructor Create(
            IEnumerable<Parameter> parameters = null,
            string description = null,
            IEnumerable<Statement> statements = null)
            => new Constructor(parameters.EmptyIfNull(), description, statements);
    }
}
