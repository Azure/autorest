namespace AutoRest.Php.JsonBuilder
{
    public interface IVisitor<R>
    {
        R Visit(String @string);
        R Visit(Boolean boolean);
        R Visit(Object @object);
        R Visit(Array @array);
    }
}
