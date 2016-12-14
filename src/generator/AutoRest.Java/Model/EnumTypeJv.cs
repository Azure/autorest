using System.Collections.Generic;
using System.Globalization;
using AutoRest.Core.Utilities;
using AutoRest.Core.Model;
using System;

namespace AutoRest.Java.Model
{
    public class EnumTypeJv : EnumType, IModelTypeJv
    {
        public EnumTypeJv()
        {
            // TODO
            Name.OnGet += name => string.IsNullOrEmpty(name) || name == "enum" ? "String" : name;
        }

        public string ModelsPackage => (this.CodeModel as CodeModelJv).ModelsPackage;
        
        public virtual IEnumerable<string> Imports
        {
            get
            {
                if (Name != "String") // TODO: refactor this madness
                {
                    yield return string.Join(".",
                        CodeModel?.Namespace?.ToLower(CultureInfo.InvariantCulture) ?? "fallbackNamespaceOrWhatTODO",
                        "models", Name);
                }
            }
        }

        public IModelTypeJv ResponseVariant => this;

        public IModelTypeJv NonNullableVariant => this;
    }
}
