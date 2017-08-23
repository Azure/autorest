using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public interface ICodeText
    {
        IEnumerable<string> ToCodeText(string indent);
    }
}
