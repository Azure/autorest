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

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return '"' + Value + '"';
        }
    }
}
