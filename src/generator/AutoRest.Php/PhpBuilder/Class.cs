using AutoRest.Php.PhpBuilder.Functions;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Class : ICodeText
    {
        public ClassName Name { get; }

        public Constructor Constructor { get; }

        public ImmutableList<Function> Functions { get; }

        public ImmutableList<Property> Properties { get; }

        public Class(
            string name,
            Constructor constructor = null,
            ImmutableList<Function> functions = null,
            ImmutableList<Property> properties = null)
        {
            Name = new ClassName(name);
            Constructor = constructor;
            Functions = functions.EmptyIfNull();
            Properties = properties.EmptyIfNull();
        }

        public static string CreateName(params string[] names)
            => string.Join("\\", names);

        public IEnumerable<string> ToCodeText(string indent)
        {
            yield return "<?php";
            yield return $"namespace {Name.PhpNamespace};";
            yield return $"final class {Name.PhpLocalName}";
            yield return "{";
            var constructorList = Constructor == null
                ? ImmutableList<ICodeText>.Empty
                : ImmutableList.Create(Constructor.UpCast<ICodeText>());
            var objects = constructorList
                .Concat(Functions)
                .Concat(Properties);
            foreach (var line in objects.SelectMany(lines => lines.ToCodeText(indent)))
            {
                yield return $"{indent}{line}";
            }
            yield return "}";
        }
    }
}
