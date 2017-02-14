using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class SequenceTypeTs : SequenceType, IImplementationNameAware
    {
        public virtual string ImplementationName
        {
            get
            {
                var name = XmlName;

                var elementType = ElementType as IImplementationNameAware;

                if (elementType != null)
                {
                    name = elementType.ImplementationName;
                }

                return $"{name}[]";
            }
        }
    }
}
