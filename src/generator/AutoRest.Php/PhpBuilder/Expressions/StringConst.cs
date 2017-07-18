﻿using System;
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

        public override string ToCodeLine()
            => '"' + Value + '"';

        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return ToCodeLine();
        }
    }
}
