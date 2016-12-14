using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class SequenceTypeJv : SequenceType, IModelTypeJv
    {
        public SequenceTypeJv()
        {
            Name.OnGet += v => $"List<{ElementType.Name}>";
        }

        public IModelTypeJv ResponseVariant
        {
            get
            {
                var respvariant = (ElementType as IModelTypeJv).ResponseVariant;
                if (respvariant != ElementType && (respvariant as PrimaryTypeJv)?.Nullable != false)
                {
                    return new SequenceTypeJv { ElementType = respvariant };
                }
                return this;
            }
        }

        public IEnumerable<string> Imports
        {
            get
            {
                List<string> imports = new List<string> { "java.util.List" };
                return imports.Concat(((IModelTypeJv) this.ElementType).Imports);
            }
        }

        public IModelTypeJv NonNullableVariant => this;
    }
}
