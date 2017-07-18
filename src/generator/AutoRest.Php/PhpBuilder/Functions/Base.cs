using AutoRest.Core.Utilities.Collections;
using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public abstract class Base : ICodeText
    {
        protected abstract string PhpName { get; }

        public abstract ClassName Return { get; }

        public IEnumerable<Parameter> Parameters { get; }

        public string Description { get; }

        public IEnumerable<Statement> Statements { get; }

        protected Base(
            IEnumerable<Parameter> parameters,
            string description,
            IEnumerable<Statement> statements)
        {
            Parameters = parameters;
            Description = description;
            Statements = statements;
        }

        public abstract IEnumerable<string> ToCodeText(string indent);

        public IEnumerable<string> GetSignature(string indent)
            => GetComment()
                .Comment()
                .Concat(Parameters
                    .ItemsWrap("(", ")", indent)
                    .InlineWrap("public function " + PhpName, string.Empty));

        protected IEnumerable<string> GetComment()
        {
            if (Description != null)
            {
                yield return Description;
            }
            foreach (var p in Parameters)
            {
                yield return "@param " + p.Type.AbsoluteName + " " + p.Name.PhpFullName;
            }
            if (Return != null)
            {
                yield return "@return " + Return.AbsoluteName;
            }
        }

        public IEnumerable<string> GetBody(string indent)
        {
            foreach (var line in GetSignature(indent))
            {
                yield return line;
            }
            yield return "{";
            foreach (var line in Statements.SelectMany(s => s.ToCodeText(indent)))
            {
                yield return $"{indent}{line}";
            }
            yield return "}";
        }
    }
}
