using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Functions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public static class PHP
    {
        public static Array Array(this IEnumerable<ArrayItem> items)
            => new Array(items);

        public static Array Array(params ArrayItem[] items)
            => new Array(items);

        public static Array EmptyArray { get; } = Array();

        public static ArrayItem KeyValue(this StringConst key, Expression value)
            => new ArrayItem(key, value);

        public static ArrayItem KeyValue(this Expression value)
            => new ArrayItem(null, value);

        public static ArrayItem KeyValue(this string key, Expression value)
            => new ArrayItem(new StringConst(key), value);

        public static ArrayItem KeyValue(this string key, string value)
            => new ArrayItem(new StringConst(key), new StringConst(value));

        public static Class Class(
            string name,
            Constructor constructor = null,
            IEnumerable<Function> functions = null,
            IEnumerable<Property> properties = null,
            IEnumerable<Const> consts = null)
            => new Class(
                name: new ClassName(name),
                constructor: constructor,
                functions: functions.EmptyIfNull(),
                properties: properties.EmptyIfNull(),
                consts: consts.EmptyIfNull());

        public static New New(ClassName type, IEnumerable<Expression> parameters)
            => new New(type, parameters);

        public static New New(ClassName type, params Expression[] parameters)
            => new New(type, parameters);

        public static Property Property(ClassName type, string name)
            => new Property(type, name);

        public static This This { get; } = new This();
    }
}
