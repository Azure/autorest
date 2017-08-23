using AutoRest.Php.PhpBuilder.Expressions;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class ObjectName : Name
    {
        public string PhpName { get; }

        public string PhpFullName { get; }

        public ObjectName(string value) : base(value)
        {
            PhpName = Original.GetPhpCamelName();
            PhpFullName = "$" + PhpName;
        }

        public ObjectRef Ref()
            => new ObjectRef(this);
    }
}
