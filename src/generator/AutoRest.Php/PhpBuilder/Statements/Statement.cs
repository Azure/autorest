using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder.Statements
{
    public abstract class Statement : ILines
    {
        public abstract IEnumerable<string> ToLines(string indent);
    }
}
