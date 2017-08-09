using System;

namespace AutoRest.Php.JsonBuilder
{
    public class Boolean : Primitive<bool>
    {
        public Boolean(bool value) : base(value)
        {
        }

        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);
    }
}
