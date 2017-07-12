using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Method : ILines
    {
        public string Name { get; }

        public string Description { get; }

        public Method(string name, string description = null)
        {
            Name = name;
            Description = description ?? string.Empty;
        }

        public IEnumerable<string> ToLines()
        {
            var name = Name.GetPhpCamelName();
            yield return "/**";
            yield return $" * {Description}";
            yield return " */";
            yield return $"public function {name}() {{";
            yield return "}";
        }
    }
}
