using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.JsonBuilder
{
    public abstract class Object : Token
    {
        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);

        public abstract IEnumerable<Property> GetProperties();
    }

    public sealed class Object<T> : Object
        where T : Token
    {
        public override IEnumerable<Property> GetProperties()
            => Properties;

        public IEnumerable<Property<T>> Properties { get; }

        public Object(IEnumerable<Property<T>> properties)
        {
            Properties = properties;
        }
    }
}
