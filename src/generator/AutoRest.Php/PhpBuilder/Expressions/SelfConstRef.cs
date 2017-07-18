using System;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class SelfConstRef : Expression0
    {
        public ConstName Name { get; }

        public SelfConstRef(ConstName name)
        {
            Name = name;
        }

        public override string ToCodeLine()
            => "self::" + Name.PhpName;

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return ToCodeLine();
        }
    }
}
