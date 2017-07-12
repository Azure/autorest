using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Class : ILines
    {
        public string Name { get; }

        public IEnumerable<Method> Methods { get; }

        public IEnumerable<Property> Properties { get; }

        public Class(
            string name,
            IEnumerable<Method> methods = null,
            IEnumerable<Property> properties = null)
        {
            Name = name;
            Methods = methods.EmptyIfNull();
            Properties = properties.EmptyIfNull();
        }

        public static string CreateName(params string[] names)
            => string.Join("\\", names);

        public IEnumerable<string> GetNames()
            => Name
                .Split(new[] { '.', '\\' });

        public string GetFileName()
            => string.Join("/", GetNames()) + ".php";

        const string Indent = "    ";

        public IEnumerable<string> ToLines()
        {
            var names = GetNames().Select(Extensions.GetPhpName).ToArray();
            var @namespace = string.Join("\\", names.Take(names.Length - 1));
            var localName = names[names.Length - 1];

            yield return "<?php";
            yield return $"namespace {@namespace};";
            yield return $"final class {localName}";
            yield return "{";
            var objects = Methods.Select(Php.Extensions.UpCast<ILines>).Concat(Properties);
            foreach (var line in objects.SelectMany(lines => lines.ToLines()))
            {
                yield return $"{Indent}{line}";
            }
            yield return "}";
        }
    }
}
