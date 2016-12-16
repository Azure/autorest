using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Model;

namespace AutoRest.Java.Model
{
    public class EnumTypeJv : EnumType, IModelTypeJv
    {
        public EnumTypeJv()
        {
            Name.OnGet += name => string.IsNullOrEmpty(name) || name == "enum" ? "String" : name;
        }

        public virtual string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;
        
        public virtual IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String")
                {
                    yield return string.Join(".",
                        CodeModel?.Namespace.ToLower(CultureInfo.InvariantCulture),
                        "models", Name);
                }
            }
        }

        public IModelTypeJv ResponseVariant => this;

        public IModelTypeJv ParameterVariant => this;

        public IModelTypeJv NonNullableVariant => this;
    }
}
