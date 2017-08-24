namespace AutoRest.Php.PhpBuilder
{
    public abstract class Name
    {
        public string Original { get; }

        protected Name(string original)
        {
            Original = original;
        }
    }
}
