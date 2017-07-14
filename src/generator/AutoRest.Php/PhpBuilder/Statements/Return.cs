using System;
using System.Collections.Generic;
using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Immutable;
using System.Linq;

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
            => Expression
                .ToLines(indent)
                .Select((v, i) 
                    => (i.IsFirst ? "return " : string.Empty) 
                        + v
                        + (i.IsLast ? ";" : string.Empty));
    }
}
