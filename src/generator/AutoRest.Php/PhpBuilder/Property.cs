using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Property : ILines
    {
        public string Name { get; }

        public Property(string name)
        {
            Name = name;
        }

        public IEnumerable<string> ToLines()
        {
            yield return $"private ${Name.GetPhpCamelName()};";
        }
    }
}
