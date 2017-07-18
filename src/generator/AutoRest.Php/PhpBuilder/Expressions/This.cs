using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Expressions
{
    public sealed class This : Expression0
    {
        public override IEnumerable<string> ToCodeText(string indent)
        {
            yield return "$this";
        }

        public static This Instance { get; }
            = new This();

        private This()
        {
        }
    }
}
