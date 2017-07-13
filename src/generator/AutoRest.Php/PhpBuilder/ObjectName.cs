using AutoRest.Php.PhpBuilder.Expressions;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class ObjectName : Name
    {
        public string PhpName { get; }

        public ObjectName(string value) : base(value)
        {
            PhpName = Original.GetPhpCamelName();
        }

        public ObjectRef Ref()
            => new ObjectRef(this);
    }
}
