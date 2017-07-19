namespace AutoRest.Php.PhpBuilder
{
    public sealed class ConstName : Name
    {
        public string PhpName { get; }

        public ConstName(string original): base(original)
        {
            PhpName = original.ToUpper();
        }

        public static implicit operator ConstName(string name)
            => new ConstName(name);
    }
}
