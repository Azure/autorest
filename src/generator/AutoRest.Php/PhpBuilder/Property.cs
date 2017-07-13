using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Property : ILines
    {
        public ObjectName Name { get; }

        public ClassName Type { get; }

        public Property(
            string name,
            ClassName type,
            bool isStatic = false)
        {
            Name = new ObjectName(name);
            Type = type;
        }

        public IEnumerable<string> ToLines(string indent)
        {
            foreach (var line in ImmutableList.Create($"@var {Type.AbsoluteName}").Comment())
            {
                yield return line;
            }
            yield return $"private ${Name.PhpName};";
        }
    }
}
