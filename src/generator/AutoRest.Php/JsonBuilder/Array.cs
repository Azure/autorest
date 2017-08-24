using System;
using System.Collections.Generic;

namespace AutoRest.Php.JsonBuilder
{
    public abstract class Array : Token
    {
        public override R Accept<R>(IVisitor<R> visitor)
            => visitor.Visit(this);

        public abstract IEnumerable<Token> GetItems();
    }

    public sealed class Array<T> : Array
        where T : Token
    {
        public IEnumerable<T> Items { get; }

        public Array(IEnumerable<T> items)
        {
            Items = items;
        }

        public override IEnumerable<Token> GetItems()
            => Items;
    }
}
