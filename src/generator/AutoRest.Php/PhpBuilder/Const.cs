using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Const : ICodeText
    {
        public ConstName Name { get; }

        public Expression Expression { get; }

        public Const(ConstName name, Expression expression)
        {
            Name = name;
            Expression = expression;
        }

        public IEnumerable<string> ToCodeText(string indent)
            => Expression
                .ToCodeText(indent)
                .InlineWrap("const " + Name.PhpName + " = ", ";");
    }
}
