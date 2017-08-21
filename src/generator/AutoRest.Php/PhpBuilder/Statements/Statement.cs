using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Statements
{
    public abstract class Statement : ICodeText
    {
        public abstract IEnumerable<string> ToCodeText(string indent);
    }
}
