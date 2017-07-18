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
            return char.ToLower(name[0]) + name.Substring(1);
        }

        public static IEnumerable<string> Comment(this IEnumerable<string> text)
        {
            yield return "/**";
            foreach (var line in text)
            {
                yield return " * " + line;
            }
            yield return " */";
        }

        public static IEnumerable<string> BinaryOperation(
            this IEnumerable<string> left, string operation, IEnumerable<string> right)
            => left
                .SelectManyWithInfo(leftInfo =>
                    leftInfo.BinaryOperationLeft(operation, right));

        private static IEnumerable<string> BinaryOperationLeft(
            this ItemInfo<string> left, string operation, IEnumerable<string> right)
        {
            if (!left.IsLast)
            {
                yield return left.Value;
            }
            else
            {
                var prefix = left.Value + operation;
                foreach(var line in right.SelectWithInfo(rightInfo => 
                    rightInfo.IsFirst.Then(prefix) + rightInfo.Value))
                {
                    yield return line;
                }
            }
        }

        public static IEnumerable<string> ItemWrap(
            this ItemInfo<ICodeText> item, string open, string close, string indent)
        {
            var lines = item.Value.ToCodeText(indent);
            // one line
            if (item.IsOnlyOne)
            {
                foreach(var line in lines.InlineWrap(open, close))
                {
                    yield return line;
                }
            }
            // multiline
            else
            {
                // first line
                if (item.IsFirst)
                {
                    yield return open;
                }
                var newLines = lines.Select(line => indent + line);
                // middle line
                if (!item.IsLast)
                {
                    foreach (var line in newLines.InlineWrap(string.Empty, ","))
                    {
                        yield return line;
                    }
                }
                // last line
                else
                {
                    foreach (var line in newLines)
                    {
                        yield return line;
                    }
                    yield return close;
                }
            }
        }

        public static IEnumerable<string> ItemsWrap(
            this IEnumerable<ICodeText> items, string open, string close, string indent)
            => items.SelectManyWithInfo(i => ItemWrap(i, open, close, indent), open + close);

        public static IEnumerable<string> InlineWrap(
            this IEnumerable<string> lines, string prefix, string suffix)
            => lines.SelectWithInfo(i
                => i.IsFirst.Then(prefix)
                    + i.Value 
                    + i.IsLast.Then(suffix));
    }
}
