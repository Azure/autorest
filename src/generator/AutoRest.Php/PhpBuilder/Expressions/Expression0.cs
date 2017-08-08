using System.Collections.Generic;
namespace AutoRest.Php.PhpBuilder.Expressions
{
    public abstract class Expression0 : Expression
    {
        public Expression Assign(Expression right)
            => new Assign(this, right);

        public Expression0 Arrow(Property right)
            => new PropertyRef(this, right.Name);

        public Expression0 Call(
            string function,
            IEnumerable<Expression> parameters)
            => new Call(this, new FunctionName(function), parameters);

        public Expression0 Call(
            string function,
            params Expression[] parameters)
            => new Call(this, new FunctionName(function), parameters);
    }
}
