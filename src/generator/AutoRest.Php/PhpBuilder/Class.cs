using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Class
    {
        public string Name { get; }

        public IEnumerable<Method> Methods { get; }

        public Class(string name, IEnumerable<Method> methods = null)
        {
            Name = name;
            Methods = methods.EmptyIfNull();
        }

        public static string CreateName(params string[] names)
            => string.Join("\\", names);

        public IEnumerable<string> GetNames()
            => Name
                .Split(new[] { '.', '\\' });

        public string GetFileName()
            => string.Join("/", GetNames()) + ".php";

        public static string GetPhpName(string name)
        {
            name = name.Replace('-', '_');
            return char.IsDigit(name[0]) ? $"_{name}" : name;
        }

        const string Indent = "    ";

        public IEnumerable<string> ToStringList()
        {
            var names = GetNames().Select(GetPhpName).ToArray();
            var @namespace = string.Join("\\", names.Take(names.Length - 1));
            var localName = names[names.Length - 1];

            yield return "<?php";
            yield return $"namespace {@namespace};";
            yield return $"final class {localName}";
            yield return "{";
            foreach (var line in Methods.SelectMany(method => method.ToStringList()))
            {
                yield return $"{Indent}{line}";
            }
            yield return "}";
        }
    }
}
