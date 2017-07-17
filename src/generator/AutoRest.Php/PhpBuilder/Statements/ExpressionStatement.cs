using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Statements
{
    public sealed class ExpressionStatement : Statement
    {
        public Expression Expression { get; }

        public ExpressionStatement(Expression expression)
        {
            Expression = expression;
        }

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return Expression.ToCodeLine() + ";";
        }
    }
}
