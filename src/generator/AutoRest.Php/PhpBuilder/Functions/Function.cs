using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Function : Base
    {
        public FunctionName Name { get; }

        public ClassName Return { get; }

        public string Description { get; }

        protected override string PhpName 
            => Name.PhpName;

        public Function(
            string name,
            ClassName @return,
            string description = null,
            ImmutableList<Statement> statements = null):
            base(statements)
        {
            Name = new FunctionName(name);
            Return = @return;
            Description = description;
        }

        private IEnumerable<string> GetComment()
        {
            if (Description != null)
            {
                yield return Description;
            }
            if (Return != null)
            {
                yield return $"@return {Return.AbsoluteName}";
            }
        }

        public override IEnumerable<string> ToCodeText(string indent)
        {
            foreach (var line in GetComment().Comment())
            {
                yield return line;
            }
            if (Statements == null)
            {
                yield return $"{GetSignature()};";
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
