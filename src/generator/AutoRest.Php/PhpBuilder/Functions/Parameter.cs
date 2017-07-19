using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Parameter : ICodeText
    {
        public ObjectName Name { get; }

        public ClassName Type { get; }

        public Parameter(ObjectName name, ClassName type)
        {
            Name = name;
            Type = type;
        }

        public IEnumerable<string> ToCodeText(string indent)
        {
            yield return Type.AbsoluteName + " " + Name.PhpFullName;
        }

        public ObjectRef Ref()
            => new ObjectRef(Name);
    }
}
