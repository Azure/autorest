using AutoRest.Php.PhpBuilder.Statements;
using AutoRest.Php.PhpBuilder.Types;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Function : Base
    {
        public FunctionName Name { get; }

        public override IType Return { get; }

        protected override string PhpName 
            => Name.PhpName;

        public Function(
            string name,
            string description,
            IEnumerable<Parameter> parameters,
            IType @return,
            IEnumerable<Statement> body):
            base(description, parameters, body)
        {
            Name = new FunctionName(name);
            Return = @return;
        }

        public override IEnumerable<string> ToCodeText(string indent)
        {
            if (Body == null)
            {
                foreach (var line in GetSignature(indent).InlineWrap(string.Empty, ";"))
                {
                    yield return line;
                }
            }
            else
            {
                foreach (var line in GetBody(indent))
                {
                    yield return line;
                }
            }
        }
    }
}
