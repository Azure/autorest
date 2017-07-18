using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Const : ICodeText
    {
        public ConstName Name { get; }

        public Expression Expression { get; }

        private Const(ConstName name, Expression expression)
        {
            Name = name;
            Expression = expression;
        }

        public static Const Create(ConstName name, Expression expression)
            => new Const(name, expression);

        public static Const Create(string name, Expression expression)
            => new Const(new ConstName(name), expression);

        public IEnumerable<string> ToCodeText(string indent)
            => Expression
                .ToCodeText(indent)
                .InlineWrap("const " + Name.PhpName + " = ", ";");
    }
}
