using AutoRest.Core.Model;

namespace AutoRest.CSharp.LoadBalanced.Legacy.Model
{
    internal class InheritedPropertyInfo
    {
        public InheritedPropertyInfo(Property property, int depth)
        {
            Property = property;
            Depth = depth;
        }

        public Property Property { get; private set; }

        public int Depth { get; private set; }
    }
}
