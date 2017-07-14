using System;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class StringConst : Expression0
    {
        public string Value { get; }

        public StringConst(string value)
        {
            Value = value;
        }

        public override string ToString()
            => $"\"{Value}\"";

        public override IEnumerable<string> ToLines(string indent)
        {
            yield return $"\"{Value}\"";
        }
    }
}
