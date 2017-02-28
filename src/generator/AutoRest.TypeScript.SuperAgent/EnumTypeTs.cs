using AutoRest.Core.Model;

namespace AutoRest.TypeScript.SuperAgent
{
    public class EnumTypeTs : EnumType, IImplementationNameAware
    {
        public EnumTypeTs()
        {
            Name.OnGet += v => ImplementationName;
        }

        public virtual string ImplementationName => "number";
    }
}
