using AutoRest.Php.PhpBuilder.Expressions;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Functions
{
    public sealed class Parameter : ICodeText
    {
        public ObjectName Name { get; }

        public ClassName Type { get; }

        private Parameter(ObjectName name, ClassName type)
        {
            Name = name;
            Type = type;
        }

        public static Parameter Create(ObjectName name, ClassName type)
            => new Parameter(name, type);

        public IEnumerable<string> ToCodeText(string indent)
        {
            yield return Name.PhpFullName;
        }

        public ObjectRef Ref()
            => new ObjectRef(Name);
    }
}
