using System;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class ObjectRef : Expression0
    {
        public ObjectName Object { get; }

        public ObjectRef(ObjectName @object)
        {
            Object = @object;
        }

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return "$" + Object.PhpName;
        }
    }
}
