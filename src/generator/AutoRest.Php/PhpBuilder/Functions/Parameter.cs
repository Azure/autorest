using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Parameter : ICodeText
    {
        public IType Type { get; }

        public ObjectName Name { get; }

        public Parameter(IType type, ObjectName name)
        {
            Type = type;
            Name = name;
        }

        public IEnumerable<string> ToCodeText(string indent)
        {
            yield return Type.AbsoluteName + " " + Name.PhpFullName;
        }

        public ObjectRef Ref()
            => new ObjectRef(Name);
    }
}
