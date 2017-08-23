using System.Collections.Generic;
using System.Linq;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Namespace
    {
        public IEnumerable<string> Names { get; }

        public IEnumerable<string> PhpNames 
            => Names.Select(Extensions.GetPhpName);

        public Namespace(IEnumerable<string> names)
        {
            Names = names;
        }
    }
}
