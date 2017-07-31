namespace AutoRest.Php.JsonBuilder
{
    public sealed class String : Token
    {
        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);

        public string Value { get; }

        public String(string value)
        {
            Value = value;
        }
    }
}
