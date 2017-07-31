using System.Collections.Generic;

namespace AutoRest.Php.JsonBuilder
{
    public static class Json
    {
        public static KeyValuePair<string, Token> Property(string name, Token value)
            => Extensions.KeyValue(name, value);

        public static Array<T> Array<T>(IEnumerable<T> items)
            where T : Token
            => new Array<T>(items);

        public static Array<T> Array<T>(params T[] items)
            where T : Token
            => new Array<T>(items);

        public static Object<T> Object<T>(IEnumerable<KeyValuePair<string, T>> items)
            where T : Token
            => new Object<T>(items);
    }
}
