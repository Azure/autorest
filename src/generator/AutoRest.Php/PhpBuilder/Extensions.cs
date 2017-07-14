using AutoRest.Php.PhpBuilder.Expressions;
using System;
using System.Collections.Generic;
using System.Collections.Immutable;
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

        public static IEnumerable<string> ToPhpCode(
            this IEnumerable<Expression> expressions, string indent)
            => expressions
                .Select((e, i) 
                    => e.ToLines(indent).Select((line, lineI)
                        => line + (!i.IsLast && lineI.IsLast ? "," : string.Empty)))
                .SelectMany(lines => lines);
    }
}
