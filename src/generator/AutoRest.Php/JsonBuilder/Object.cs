using System;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.JsonBuilder
{
    public abstract class Object : Token
    {
        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);

        public abstract IEnumerable<KeyValuePair<string, Token>> GetProperties();
    }

    public sealed class Object<T> : Object
        where T : Token
    {
        public override IEnumerable<KeyValuePair<string, Token>> GetProperties()
            => Properties.Select(v => new KeyValuePair<string, Token>(v.Key, v.Value));

        public IEnumerable<KeyValuePair<string, T>> Properties { get; }

        public Object(IEnumerable<KeyValuePair<string, T>> properties)
        {
            Properties = properties;
        }
    }
}
