using System.Collections.Generic;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class Method
    {
        public string Name { get; }

        public string Description { get; }

        public Method(string name, string description)
        {
            Name = name;
            Description = description;
        }

        public IEnumerable<string> ToStringList()
        {
            yield return "/**";
            yield return $" * {Description}";
            yield return " */";
            yield return $"public function {Name}() {{";
            yield return "}";
        }
    }
}
