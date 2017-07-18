using AutoRest.Php.PhpBuilder.Expressions;

namespace AutoRest.Php.PhpBuilder
{
    public sealed class ConstName : Name
    {
        public string PhpName { get; }

        public ConstName(string original): base(original)
        {
            PhpName = original.ToUpper();
        }

        public SelfConstRef SelfConstRef()
            => new SelfConstRef(this);
    }
}
