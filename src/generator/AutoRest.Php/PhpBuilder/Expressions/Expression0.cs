using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public abstract class Expression0 : Expression
    {
        public Expression Assign(Expression right)
            => new Assign(this, right);

        public Expression0 PropertyRef(ObjectName right)
            => new PropertyRef(this, right);

        public Expression0 Call(
            FunctionName function,
            ImmutableList<Expression> parameters = null)
            => new Call(this, function, parameters);
    }
}
