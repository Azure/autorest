using AutoRest.Core.Utilities.Collections;
using AutoRest.Php.PhpBuilder.Statements;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public abstract class Base : ICodeText
    {
        protected abstract string PhpName { get; }

        public ImmutableList<Statement> Statements { get; }

        protected Base(ImmutableList<Statement> statements)
        {
            Statements = statements;
        }

        public abstract IEnumerable<string> ToCodeText(string indent);

        public string GetSignature()
            => $"public function {PhpName}()";

        public IEnumerable<string> GetBody(string indent)
        {
            yield return GetSignature();
            yield return "{";
            foreach (var line in Statements.SelectMany(s => s.ToCodeText(indent)))
            {
                yield return $"{indent}{line}";
            }
            yield return "}";
        }
    }
}
