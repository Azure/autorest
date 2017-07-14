using System;
using System.Collections.Generic;
using System.Collections.Immutable;
using System.Linq;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class PropertyRef : Expression0
    {
        public Expression0 Left { get; }

        public ObjectName Right { get; }

        public PropertyRef(Expression0 left, ObjectName right)
        {
            Left = left;
            Right = right;
        }

        public override string ToString()
            => $"{Left.ToString()}->{Right.PhpName}";

        public override IEnumerable<string> ToLines(string indent)
            => Left
                .ToLines(indent)
                .Select((v, i) => v + (i.IsLast ? "->" + Right.PhpName : string.Empty));
    }
}
