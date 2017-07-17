using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder
{
    public static class Extensions
    {
        public static string GetPhpName(this string name)
        {
            name = name.Replace('-', '_');
            switch(name.ToLower())
            {
                case "list":
                    name += "_";
                    break;
            }
            return char.IsDigit(name[0]) ? $"_{name}" : name;
        }

        public static string GetPhpCamelName(this string name)
        {
            name = name.GetPhpName();
            return $"{char.ToLower(name[0])}{name.Substring(1)}";
        }

        public static IEnumerable<string> Comment(this IEnumerable<string> text)
        {
            yield return "/**";
            foreach (var line in text)
            {
                yield return $" * {line}";
            }
            yield return " */";
        }

        public static string ToPhpCode(this IEnumerable<Expression> expressions)
            => string.Join(", ", expressions.Select(v => v.ToCodeLine()));
    }
}
