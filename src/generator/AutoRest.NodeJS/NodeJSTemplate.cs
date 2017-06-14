using AutoRest.Core;

namespace AutoRest.NodeJS
{
    public class NodeJSTemplate<T> : Template<T>
    {
        public override string WrapComment(string prefix, string comment)
        {
            return base.WrapComment(prefix, comment);
        }
    }
}
