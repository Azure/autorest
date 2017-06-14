using System.Collections.Generic;
using System.Linq;
using AutoRest.Core.Model;
using Newtonsoft.Json;

namespace AutoRest.Java.Model
{
    public class SequenceTypeJv : SequenceType, IModelTypeJv
    {
        public SequenceTypeJv()
        {
            Name.OnGet += v => $"List<{ElementType.Name}>";
        }

        [JsonIgnore]
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

        [JsonIgnore]
        public IModelTypeJv ParameterVariant
        {
            get
            {
                var respvariant = (ElementType as IModelTypeJv).ParameterVariant;
                if (respvariant != ElementType && (respvariant as PrimaryTypeJv)?.Nullable != false)
                {
                    return new SequenceTypeJv { ElementType = respvariant };
                }
                return this;
            }
        }

        [JsonIgnore]
        public IEnumerable<string> Imports
        {
            get
            {
                List<string> imports = new List<string> { "java.util.List" };
                return imports.Concat(((IModelTypeJv) this.ElementType).Imports);
            }
        }

        [JsonIgnore]
        public IModelTypeJv NonNullableVariant => this;
    }
}
