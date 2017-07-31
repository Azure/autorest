namespace AutoRest.Php.JsonBuilder
{
    public interface IVisitor<R>
    {
        R Visit(String @string);
        R Visit(Object @object);
        R Visit(Array @array);
    }
}
