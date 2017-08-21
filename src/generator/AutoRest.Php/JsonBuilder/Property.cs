namespace AutoRest.Php.JsonBuilder
{
    public abstract class Property
    {
        public string Name { get; }

        public abstract Token GetValue();

        protected Property(string name)
        {
            Name = name;
        }
    }

    public sealed class Property<T> : Property
        where T : Token
    {
        public override Token GetValue() => Value;

        public T Value { get; }

        public Property(string name, T value): base(name)
        {
            Value = value;
        }
    }
}
