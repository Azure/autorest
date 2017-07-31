using System.Collections.Generic;

namespace AutoRest.Php.JsonBuilder
{
    public static class Json
    {
        public static Property<T> Property<T>(string name, T value)
            where T : Token
            => new Property<T>(name, value);

        public static Property<String> Property(string name, string value)
            => new Property<String>(name, new String(value));

        public static Array<T> Array<T>(IEnumerable<T> items)
            where T : Token
            => new Array<T>(items);

        public static Array<T> Array<T>(params T[] items)
            where T : Token
            => new Array<T>(items);

        public static Object<T> Object<T>(IEnumerable<Property<T>> items)
            where T : Token
            => new Object<T>(items);
    }
}
