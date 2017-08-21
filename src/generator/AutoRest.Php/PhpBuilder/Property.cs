using System.Collections.Generic;
using System.Collections.Immutable;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Property : ICodeText
    {
        public ClassName Type { get; }

        public ObjectName Name { get; }

        public Property(            
            ClassName type,
            string name)
        {
            Type = type;
            Name = new ObjectName(name);
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
