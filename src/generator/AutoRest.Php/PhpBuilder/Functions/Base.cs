using AutoRest.Core.Utilities.Collections;
using AutoRest.Php.PhpBuilder.Statements;
using AutoRest.Php.PhpBuilder.Types;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public abstract class Base : ICodeText
    {
        protected abstract string PhpName { get; }

        public abstract IType Return { get; }

        public string Description { get; }

        public IEnumerable<Parameter> Parameters { get; }

        public IEnumerable<Statement> Body { get; }

        protected Base(
            string description,
            IEnumerable<Parameter> parameters,
            IEnumerable<Statement> body)
        {
            Description = description;
            Parameters = parameters;
            Body = body;
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
            foreach (var line in Body.SelectMany(s => s.ToCodeText(indent)))
            {
                yield return $"{indent}{line}";
            }
            yield return "}";
        }
    }
}
