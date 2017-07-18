using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Property : ICodeText
    {
        public ObjectName Name { get; }

        public ClassName Type { get; }

        public Property(
            string name,
            ClassName type)
        {
            Name = new ObjectName(name);
            Type = type;
        }

        public IEnumerable<string> ToCodeText(string indent)
        {
            foreach (var line in ImmutableList.Create($"@var {Type.AbsoluteName}").Comment())
            {
                yield return line;
            }
            yield return "private " + Name.PhpFullName + ";";
        }
    }
}
