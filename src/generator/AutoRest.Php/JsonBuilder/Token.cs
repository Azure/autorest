namespace AutoRest.Php.JsonBuilder
{
    public abstract class Token
    {
        public abstract R Accept<R>(IVisitor<R> visitor);

        public static implicit operator Token(string value)
            => new String(value);
    }
}
