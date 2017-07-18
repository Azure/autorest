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

        public IEnumerable<Function> Functions { get; }

        public IEnumerable<Property> Properties { get; }

        public IEnumerable<Const> Consts { get; }

        public Class(
            ClassName name,
            Constructor constructor,
            IEnumerable<Function> functions,
            IEnumerable<Property> properties,
            IEnumerable<Const> consts)
        {
            Name = name;
            Constructor = constructor;
            Functions = functions;
            Properties = properties;
            Consts = consts;
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
                .Concat(Properties)
                .Concat(Consts);
            foreach (var line in objects.SelectMany(lines => lines.ToCodeText(indent)))
            {
                yield return $"{indent}{line}";
            }
            yield return "}";
        }
    }
}
