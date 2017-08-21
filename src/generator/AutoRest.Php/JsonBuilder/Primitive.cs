namespace AutoRest.Php.JsonBuilder
{
    public abstract class Primitive<T> : Token
    {
        public T Value { get; }

        protected Primitive(T value)
        {
            Value = value;
        }
    }
}
