using System;
using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class BooleanConst : Expression0
    {
        public bool Value { get; }

        public BooleanConst(bool value)
        {
            Value = value;
        }

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return  Value ? "TRUE" : "FALSE";
        }
    }
}
