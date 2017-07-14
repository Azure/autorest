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

        public static string ToPhpCode(this IEnumerable<Expression> expressions)
            => string.Join(", ", expressions);

        public sealed class Borders<T>
        {
            public T Value { get; }

            public bool IsFirst { get; }

            public bool IsLast { get; }

            public Borders(T value, bool isFirst, bool isLast)
            {
                Value = value;
                IsFirst = isFirst;
                IsLast = isLast;
            }
        }

        public static IEnumerable<Borders<T>> WithBorders<T>(
            this IEnumerable<T> items)
        {
            bool isFirst = true;
            bool hasPrevious = false;
            T previous = default(T);
            foreach (var item in items)
            {
                if (hasPrevious)
                {
                    yield return new Borders<T>(previous, isFirst, false);
                    isFirst = false;
                }
                previous = item;
            }
            if (hasPrevious)
            {
                yield return new Borders<T>(previous, isFirst, true);
            }
        }

        /*
        public static IEnumerable<string> TransformLast(
            this IEnumerable<string> lines, Func<string, IEnumerable<string>> func)
        {
            string lastLine = null;
            foreach (var line in lines)
            {
                if (lastLine != null)
                {
                    yield return lastLine;
                }
                lastLine = line;
            }
            if (lastLine != null)
            {
                foreach (var x in func(lastLine))
                {
                    yield return x;
                }
            }
        }

        public static IEnumerable<string> TransformFirst(
            this IEnumerable<string> lines, Func<string, IEnumerable<string>> func)
        {
            bool notFirstLine = false;
            foreach (var line in lines)
            {
                if (notFirstLine)
                {
                    yield return line;
                }
                else
                {
                    foreach(var x in func(line))
                    {
                        yield return x;
                    }
                    notFirstLine = true;
                }
            }
        }
        */

        public static IEnumerable<string> BinaryOperation(
            this IEnumerable<string> left,
            string operation,
            IEnumerable<string> right,
            string indent)
            => left
                .WithBorders()
                .SelectMany(li => li.IsLast
                    ? right.WithBorders().Select(ri => ri.IsFirst 
                        ? $"{li.Value}{operation}{ri.Value}"
                        : ri.Value)
                    : new[] { li.Value });

        public static IEnumerable<string> BinaryOperation(
            this Expression left, 
            string operation,
            Expression right,
            string indent)
        {
            var leftLines = left.ToLines(indent);
            var rightLines = right.ToLines(indent);
            return leftLines.BinaryOperation(operation, rightLines, indent);
        }
    }
}
