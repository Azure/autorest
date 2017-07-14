using AutoRest.Php.PhpBuilder.Expressions;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Statements
{
    public sealed class ExpressionStatement : Statement
    {
        public Expression Expression { get; }

        public ExpressionStatement(Expression expression)
        {
            Expression = expression;
        }

        public override IEnumerable<string> ToLines(string indent)
            => Expression
                .ToLines(indent)
                .Select((v, i) => v + (i.IsLast ? ";" : string.Empty));
    }
}
