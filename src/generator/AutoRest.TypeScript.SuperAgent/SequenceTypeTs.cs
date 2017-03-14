using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class SequenceTypeTs : SequenceType, IImplementationNameAware
    {
        public virtual string ImplementationName => CreateSeqTypeText(ElementTypeImplementationName);

        internal static string CreateSeqTypeText(string implementationName)
        {
            return $"{implementationName}[]";
        }

        public string ElementTypeImplementationName
        {
            get
            {
                var name = XmlName;

                var elementType = ElementType as IImplementationNameAware;

                if (elementType != null)
                {
                    name = elementType.ImplementationName;
                }

                return name;
            }
        }
    }
}
