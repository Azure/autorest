using AutoRest.Php.PhpBuilder.Expressions;
using AutoRest.Php.PhpBuilder.Types;
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
            yield return Type.ToParameterPrefix() + Name.PhpFullName + Type.ToParameterSuffix();
        }

        public ObjectRef Ref()
            => new ObjectRef(Name);
    }
}
