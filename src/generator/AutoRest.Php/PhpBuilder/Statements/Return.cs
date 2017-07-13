using System;
using System.Collections.Generic;
using AutoRest.Php.PhpBuilder.Expressions;

namespace AutoRest.Php.PhpBuilder.Statements
{
    public sealed class Return : Statement
    {
        public Expression Expression { get; }

        public Return(Expression expression)
        {
            Expression = expression;
        }

        public override IEnumerable<string> ToLines(string indent)
        {
            yield return $"return {Expression.ToString()};";
        }
    }
}
