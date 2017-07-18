using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Function : Base
    {
        public FunctionName Name { get; }

        public override ClassName Return { get; }

        public string Description { get; }

        protected override string PhpName 
            => Name.PhpName;

        private Function(
            string name,
            ClassName @return,
            IEnumerable<Parameter> parameters,
            string description,
            IEnumerable<Statement> statements):
            base(parameters, description, statements)
        {
            Name = new FunctionName(name);
            Return = @return;
            Description = description;
        }

        public static Function Create(
            string name,
            ClassName @return = null,
            IEnumerable<Parameter> parameters = null,
            string description = null,
            IEnumerable<Statement> statements = null)
            => new Function(
                name: name,
                @return: @return,
                parameters: parameters.EmptyIfNull(),
                description: description,
                statements: statements);

        public override IEnumerable<string> ToCodeText(string indent)
        {
            if (Statements == null)
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
