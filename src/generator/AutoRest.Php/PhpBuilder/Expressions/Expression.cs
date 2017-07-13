using AutoRest.Php.PhpBuilder.Statements;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    /// <summary>
    /// See http://php.net/manual/en/language.operators.precedence.php
    /// 
    /// Expression:
    ///     Assign(Expression0, Expression),
    ///     New,
    ///     Expression0
    /// Expression0: 
    ///     ThisPropertyRef
    /// </summary>
    public abstract class Expression
    {
        public Statement Return()
            => new Return(this);

        public Statement Statement()
            => new ExpressionStatement(this);
    }
}
