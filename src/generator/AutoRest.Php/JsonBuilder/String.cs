namespace AutoRest.Php.JsonBuilder
{
    public sealed class String : Primitive<string>
    {
        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);

        public String(string value) : base(value)
        {
        }
    }
}
