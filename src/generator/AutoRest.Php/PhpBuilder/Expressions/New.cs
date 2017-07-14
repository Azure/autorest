using System;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class New : Expression
    {
        public ClassName Type { get; }

        public New(ClassName type)
        {
            Type = type;
        }

        public override string ToString()
            => $"new {Type.AbsoluteName}";

        public override IEnumerable<string> ToLines(string indent)
        {
            yield return $"new {Type.AbsoluteName}";
        }
    }
}
